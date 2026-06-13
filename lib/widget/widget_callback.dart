import 'package:drift/drift.dart';
import 'package:flutter/widgets.dart';

import '../data/database/app_database.dart';

/// Callback exécuté dans un isolate d'arrière-plan (réveillé par home_widget)
/// quand l'utilisateur valide une intensité depuis le widget.
///
/// Insère l'entrée émotionnelle dans la base Drift partagée, en réutilisant la
/// sérialisation du schéma existant. L'`emotion_id` est résolu par nom (les 20
/// émotions GEW sont uniques) pour rester découplé des ids de seed.
///
/// Volontairement local-only : aucune initialisation Supabase ni appel réseau
/// ici (l'isolate d'arrière-plan est fragile et réutilisé). L'envoi vers le
/// serveur est délégué à `SharedEntrySync.pushPending` au retour de l'app au
/// premier plan (upsert idempotent).
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

    await db.into(db.entries).insert(
          EntriesCompanion.insert(
            parentId: parent.id,
            emotionId: emotion.id,
            intensity: intensity,
          ),
        );
  } catch (e, st) {
    // Un échec silencieux côté widget serait invisible : on le trace.
    debugPrint('[dionysus.widget] échec insertion: $e\n$st');
  } finally {
    await db.close();
  }
}
