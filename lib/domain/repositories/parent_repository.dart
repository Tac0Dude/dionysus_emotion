import '../entities/parent.dart';

abstract class ParentRepository {
  Future<int> createParent({
    required String firstName,
    required String babyFirstName,
    required DateTime babyBirthDate,
    required int gestationalAgeWeeks,
    required int stageId,
    int? coparentId,
    bool sharingConsent = false,
  });

  Future<Parent?> getCurrentParent();

  Stream<Parent?> watchCurrentParent();

  Future<void> updateSharingConsent({
    required int parentId,
    required bool consent,
  });

  Future<void> updateStage({
    required int parentId,
    required int stageId,
  });

  Future<void> updateFirstName({
    required int parentId,
    required String firstName,
  });

  Future<void> updateBaby({
    required int parentId,
    required String babyFirstName,
    required DateTime babyBirthDate,
    required int gestationalAgeWeeks,
  });
}
