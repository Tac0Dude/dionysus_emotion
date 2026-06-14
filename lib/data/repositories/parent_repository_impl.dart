import 'package:drift/drift.dart';

import '../../domain/entities/parent.dart';
import '../../domain/repositories/parent_repository.dart';
import '../database/app_database.dart';
import 'mappers.dart';

class ParentRepositoryImpl implements ParentRepository {
  final AppDatabase _db;

  ParentRepositoryImpl(this._db);

  @override
  Future<int> createParent({
    required String firstName,
    required String babyFirstName,
    required DateTime babyBirthDate,
    required int gestationalAgeWeeks,
    required int stageId,
    int? coparentId,
    bool sharingConsent = false,
  }) {
    return _db.into(_db.parents).insert(
          ParentsCompanion.insert(
            firstName: firstName,
            babyFirstName: babyFirstName,
            babyBirthDate: babyBirthDate,
            gestationalAgeWeeks: gestationalAgeWeeks,
            stageId: stageId,
            coparentId: Value(coparentId),
            sharingConsent: Value(sharingConsent),
          ),
        );
  }

  @override
  Future<Parent?> getCurrentParent() async {
    final row = await (_db.select(_db.parents)
          ..orderBy([(p) => OrderingTerm.asc(p.createdAt)])
          ..limit(1))
        .getSingleOrNull();
    return row?.toDomain();
  }

  @override
  Stream<Parent?> watchCurrentParent() {
    return (_db.select(_db.parents)
          ..orderBy([(p) => OrderingTerm.asc(p.createdAt)])
          ..limit(1))
        .watchSingleOrNull()
        .map((row) => row?.toDomain());
  }

  @override
  Future<void> updateSharingConsent({
    required int parentId,
    required bool consent,
  }) async {
    await (_db.update(_db.parents)..where((p) => p.id.equals(parentId))).write(
      ParentsCompanion(sharingConsent: Value(consent)),
    );
  }

  @override
  Future<void> updateStage({
    required int parentId,
    required int stageId,
  }) async {
    await (_db.update(_db.parents)..where((p) => p.id.equals(parentId))).write(
      ParentsCompanion(stageId: Value(stageId)),
    );
  }

  @override
  Future<void> updateFirstName({
    required int parentId,
    required String firstName,
  }) async {
    await (_db.update(_db.parents)..where((p) => p.id.equals(parentId))).write(
      ParentsCompanion(firstName: Value(firstName)),
    );
  }

  @override
  Future<void> updateBaby({
    required int parentId,
    required String babyFirstName,
    required DateTime babyBirthDate,
    required int gestationalAgeWeeks,
  }) async {
    await (_db.update(_db.parents)..where((p) => p.id.equals(parentId))).write(
      ParentsCompanion(
        babyFirstName: Value(babyFirstName),
        babyBirthDate: Value(babyBirthDate),
        gestationalAgeWeeks: Value(gestationalAgeWeeks),
      ),
    );
  }
}
