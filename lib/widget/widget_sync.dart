import 'dart:io';

import 'package:flutter/services.dart';

import '../domain/repositories/entry_repository.dart';
import '../domain/repositories/parent_repository.dart';
import '../domain/repositories/reference_repository.dart';

/// Pont app → widget Android natif.
///
/// Le widget natif lit son état dans ses propres `SharedPreferences` et ne les
/// met à jour que lors d'une saisie faite *depuis le widget*. Sans ce pont, une
/// saisie réalisée dans l'app n'atteint jamais le widget : il continue d'afficher
/// l'ancienne saisie et bascule à tort en mode invitation. On pousse donc la
/// dernière saisie connue de la base vers le widget après chaque enregistrement
/// et au démarrage de l'app.
class WidgetSync {
  static const MethodChannel _channel = MethodChannel('dionysus/widget');

  /// Recalcule la dernière saisie du parent courant depuis la base et la pousse
  /// vers le widget. La base reste l'unique source de vérité, ce qui garde le
  /// widget cohérent quelle que soit l'origine de la saisie (app ou widget).
  static Future<void> refreshFromDb({
    required ParentRepository parentRepo,
    required EntryRepository entryRepo,
    required ReferenceRepository referenceRepo,
  }) async {
    if (!Platform.isAndroid) return;

    final parent = await parentRepo.getCurrentParent();
    if (parent == null) return;

    final entry = await entryRepo.getLatestForParent(parent.id);
    if (entry == null) return;

    final emotion = await referenceRepo.getEmotion(entry.emotionId);
    if (emotion == null) return;

    await _syncLastEntry(
      quadrantId: emotion.quadrantId,
      emotionName: emotion.name,
      intensity: entry.intensity,
      createdAt: entry.createdAt,
    );
  }

  static Future<void> _syncLastEntry({
    required int quadrantId,
    required String emotionName,
    required int intensity,
    required DateTime createdAt,
  }) async {
    try {
      await _channel.invokeMethod<void>('syncLastEntry', {
        'quadrant': quadrantId,
        'emotion': emotionName,
        'intensity': intensity,
        'timestamp': createdAt.millisecondsSinceEpoch,
      });
    } on PlatformException {
      // Le widget n'est pas critique : on ignore silencieusement un échec natif.
    } on MissingPluginException {
      // Canal indisponible (ex. tests) : sans effet.
    }
  }
}
