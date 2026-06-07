import 'package:drift/drift.dart';

import '../../domain/entities/entry.dart';
import '../../domain/repositories/entry_repository.dart';
import '../database/app_database.dart';
import 'mappers.dart';

class EntryRepositoryImpl implements EntryRepository {
  final AppDatabase _db;

  EntryRepositoryImpl(this._db);

  @override
  Future<int> createEntry({
    required int parentId,
    required int emotionId,
    required int intensity,
    int? activityId,
    int? locationId,
    DateTime? createdAt,
  }) {
    return _db.into(_db.entries).insert(
          EntriesCompanion.insert(
            parentId: parentId,
            emotionId: emotionId,
            intensity: intensity,
            activityId: Value(activityId),
            locationId: Value(locationId),
            createdAt: createdAt != null ? Value(createdAt) : const Value.absent(),
          ),
        );
  }

  @override
  Future<Entry?> getById(int id) async {
    final row = await (_db.select(_db.entries)..where((e) => e.id.equals(id)))
        .getSingleOrNull();
    return row?.toDomain();
  }

  @override
  Stream<List<Entry>> watchAllForParent(int parentId) {
    return (_db.select(_db.entries)
          ..where((e) => e.parentId.equals(parentId))
          ..orderBy([(e) => OrderingTerm.desc(e.createdAt)]))
        .watch()
        .map((rows) => rows.map((r) => r.toDomain()).toList());
  }

  @override
  Future<List<Entry>> getForDay({
    required int parentId,
    required DateTime day,
  }) async {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    final rows = await (_db.select(_db.entries)
          ..where((e) =>
              e.parentId.equals(parentId) &
              e.createdAt.isBiggerOrEqualValue(start) &
              e.createdAt.isSmallerThanValue(end))
          ..orderBy([(e) => OrderingTerm.asc(e.createdAt)]))
        .get();
    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<void> deleteEntry(int id) async {
    await (_db.delete(_db.entries)..where((e) => e.id.equals(id))).go();
  }
}
