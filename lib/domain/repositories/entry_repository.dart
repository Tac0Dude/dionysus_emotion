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

  Stream<List<Entry>> watchAllForParent(int parentId);

  Future<List<Entry>> getForDay({
    required int parentId,
    required DateTime day,
  });

  Future<void> deleteEntry(int id);
}
