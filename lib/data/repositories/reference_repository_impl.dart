import 'package:drift/drift.dart';

import '../../domain/entities/activity.dart';
import '../../domain/entities/emotion.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/quadrant.dart';
import '../../domain/entities/stage.dart';
import '../../domain/repositories/reference_repository.dart';
import '../database/app_database.dart';
import 'mappers.dart';

class ReferenceRepositoryImpl implements ReferenceRepository {
  final AppDatabase _db;

  ReferenceRepositoryImpl(this._db);

  @override
  Future<List<Quadrant>> getQuadrants() async {
    final rows = await (_db.select(_db.quadrants)
          ..orderBy([(q) => OrderingTerm.asc(q.id)]))
        .get();
    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<Quadrant?> getQuadrant(int id) async {
    final row = await (_db.select(_db.quadrants)..where((q) => q.id.equals(id)))
        .getSingleOrNull();
    return row?.toDomain();
  }

  @override
  Future<List<Emotion>> getEmotionsForQuadrant(int quadrantId) async {
    final rows = await (_db.select(_db.emotions)
          ..where((e) => e.quadrantId.equals(quadrantId))
          ..orderBy([(e) => OrderingTerm.asc(e.id)]))
        .get();
    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<List<Emotion>> getAllEmotions() async {
    final rows = await (_db.select(_db.emotions)
          ..orderBy([(e) => OrderingTerm.asc(e.id)]))
        .get();
    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<Emotion?> getEmotion(int id) async {
    final row = await (_db.select(_db.emotions)..where((e) => e.id.equals(id)))
        .getSingleOrNull();
    return row?.toDomain();
  }

  @override
  Future<List<Stage>> getStages() async {
    final rows = await (_db.select(_db.stages)
          ..orderBy([(s) => OrderingTerm.asc(s.id)]))
        .get();
    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<Stage?> getStageByCode(String code) async {
    final row = await (_db.select(_db.stages)..where((s) => s.code.equals(code)))
        .getSingleOrNull();
    return row?.toDomain();
  }

  @override
  Future<List<Activity>> getActivities() async {
    final rows = await (_db.select(_db.activities)
          ..orderBy([(a) => OrderingTerm.asc(a.id)]))
        .get();
    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<Activity?> getActivity(int id) async {
    final row = await (_db.select(_db.activities)..where((a) => a.id.equals(id)))
        .getSingleOrNull();
    return row?.toDomain();
  }

  @override
  Future<List<Location>> getLocations() async {
    final rows = await (_db.select(_db.locations)
          ..orderBy([(l) => OrderingTerm.asc(l.id)]))
        .get();
    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<Location?> getLocation(int id) async {
    final row = await (_db.select(_db.locations)..where((l) => l.id.equals(id)))
        .getSingleOrNull();
    return row?.toDomain();
  }
}
