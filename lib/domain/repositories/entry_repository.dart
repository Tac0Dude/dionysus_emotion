import '../entities/entry.dart';

abstract class EntryRepository {
  Future<int> createEntry({
    required int parentId,
    required int emotionId,
    required int intensity,
    int? activityId,
    int? locationId,
    DateTime? createdAt,
  });

  Future<Entry?> getById(int id);

  /// Dernière saisie (toutes dates) du parent, ou null s'il n'en a aucune.
  Future<Entry?> getLatestForParent(int parentId);

  Stream<List<Entry>> watchAllForParent(int parentId);

  /// Force les streams de saisies à relire la base. Nécessaire après une saisie
  /// faite via le widget : elle est écrite par une autre connexion SQLite, qui
  /// ne notifie pas le cache de streams de l'app.
  Future<void> refreshEntryStreams();

  Future<List<Entry>> getForDay({
    required int parentId,
    required DateTime day,
  });

  Future<void> deleteEntry(int id);
}
