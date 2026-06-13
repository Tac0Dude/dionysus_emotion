import '../../domain/entities/shared_emotion.dart';
import '../../domain/repositories/coparent_repository.dart';
import '../../domain/repositories/entry_repository.dart';
import '../../domain/repositories/parent_repository.dart';
import '../../domain/repositories/reference_repository.dart';

/// Pousse les saisies locales vers le backend partagé.
///
/// Source de vérité = SQLite local. On envoie un projeté dénormalisé
/// (émotion + quadrant + intensité + date) via un upsert idempotent sur
/// `(owner_id, client_entry_id)`. Idempotent → on peut rejouer sans risque,
/// ce qui couvre aussi les saisies faites via le widget (autre connexion SQLite).
class SharedEntrySync {
  final CoparentRepository _coparent;
  final EntryRepository _entries;
  final ParentRepository _parents;
  final ReferenceRepository _reference;

  SharedEntrySync({
    required CoparentRepository coparent,
    required EntryRepository entries,
    required ParentRepository parents,
    required ReferenceRepository reference,
  })  : _coparent = coparent,
        _entries = entries,
        _parents = parents,
        _reference = reference;

  bool _running = false;

  /// Synchronise le profil + toutes les saisies locales. Sans effet si le
  /// backend n'est pas disponible. Protégé contre les exécutions concurrentes.
  Future<void> pushPending() async {
    if (!_coparent.isAvailable || _running) return;
    _running = true;
    try {
      final parent = await _parents.getCurrentParent();
      if (parent == null) return;
      // Aucune donnée ne quitte l'appareil tant que le parent n'a pas consenti
      // au partage.
      if (!parent.sharingConsent) return;

      await _coparent.ensureProfile(parent.firstName);

      final entries = await _entries.getAllForParent(parent.id);
      if (entries.isEmpty) return;

      final emotions = {
        for (final e in await _reference.getAllEmotions()) e.id: e
      };
      final quadrantLabel = {
        for (final q in await _reference.getQuadrants()) q.id: q.label
      };

      final uploads = <SharedEntryUpload>[];
      for (final entry in entries) {
        final emotion = emotions[entry.emotionId];
        if (emotion == null) continue;
        uploads.add(SharedEntryUpload(
          clientEntryId: entry.id,
          emotionName: emotion.name,
          quadrantLabel: quadrantLabel[emotion.quadrantId] ?? '',
          intensity: entry.intensity,
          createdAt: entry.createdAt,
        ));
      }

      await _coparent.pushEntries(uploads);
    } catch (_) {
      // Best-effort : un échec réseau ne doit pas perturber l'app.
    } finally {
      _running = false;
    }
  }
}
