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

  Future<List<Entry>> getForDay({
    required int parentId,
    required DateTime day,
  });

  Future<void> deleteEntry(int id);
}
