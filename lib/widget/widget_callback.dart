import 'package:drift/drift.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';
import '../data/database/app_database.dart';

/// Évite de ré-initialiser Supabase à chaque réveil : l'isolate d'arrière-plan
/// de home_widget est réutilisé entre les saisies.
bool _supabaseReady = false;

/// Callback exécuté dans un isolate d'arrière-plan (réveillé par home_widget)
/// quand l'utilisateur valide une intensité depuis le widget.
///
/// Insère l'entrée émotionnelle dans la base Drift partagée, en réutilisant la
/// sérialisation du schéma existant. L'`emotion_id` est résolu par nom (les 20
/// émotions GEW sont uniques) pour rester découplé des ids de seed.
@pragma('vm:entry-point')
Future<void> widgetBackgroundCallback(Uri? uri) async {
  if (uri == null || uri.host != 'save') return;
  WidgetsFlutterBinding.ensureInitialized();

  final params = uri.queryParameters;
  final emotionName = params['emotion'];
  final intensity = int.tryParse(params['intensity'] ?? '');
  if (emotionName == null || emotionName.isEmpty || intensity == null) return;

  final db = AppDatabase();
  try {
    final parent = await (db.select(db.parents)
          ..orderBy([(p) => OrderingTerm.asc(p.createdAt)])
          ..limit(1))
        .getSingleOrNull();
    if (parent == null) return;

    final emotion = await (db.select(db.emotions)
          ..where((e) => e.name.equals(emotionName))
          ..limit(1))
        .getSingleOrNull();
    if (emotion == null) return;

    final createdAt = DateTime.now();
    final entryId = await db.into(db.entries).insert(
          EntriesCompanion.insert(
            parentId: parent.id,
            emotionId: emotion.id,
            intensity: intensity,
            createdAt: Value(createdAt),
          ),
        );

    // Best-effort : pousse aussi vers le serveur pour que le co-parent voie la
    // saisie sans attendre la prochaine ouverture de l'app. En cas d'échec
    // (hors-ligne, session non restaurée…), la saisie sera synchronisée au
    // prochain retour au premier plan via SharedEntrySync.pushPending (upsert
    // idempotent sur le même client_entry_id).
    await _pushToServer(
      db: db,
      parent: parent,
      emotion: emotion,
      intensity: intensity,
      clientEntryId: entryId,
      createdAt: createdAt,
    );
  } finally {
    await db.close();
  }
}

Future<void> _pushToServer({
  required AppDatabase db,
  required ParentRow parent,
  required EmotionRow emotion,
  required int intensity,
  required int clientEntryId,
  required DateTime createdAt,
}) async {
  if (!SupabaseConfig.isConfigured || !parent.sharingConsent) return;
  try {
    if (!_supabaseReady) {
      await Supabase.initialize(
        url: SupabaseConfig.url,
        publishableKey: SupabaseConfig.anonKey,
      );
      _supabaseReady = true;
    }
    final client = Supabase.instance.client;
    final uid = client.auth.currentUser?.id;
    if (uid == null) return;

    final quadrant = await (db.select(db.quadrants)
          ..where((q) => q.id.equals(emotion.quadrantId))
          ..limit(1))
        .getSingleOrNull();

    await client.from('shared_entries').upsert({
      'owner_id': uid,
      'client_entry_id': clientEntryId,
      'emotion_name': emotion.name,
      'quadrant_label': quadrant?.label ?? '',
      'intensity': intensity,
      'created_at': createdAt.toIso8601String(),
    }, onConflict: 'owner_id,client_entry_id');
  } catch (_) {
    // Ignoré : la synchronisation de secours côté app rattrapera l'envoi.
  }
}
