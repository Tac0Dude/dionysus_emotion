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

  Future<Parent?> getById(int id);

  Stream<Parent?> watchCurrentParent();

  Future<void> updateSharingConsent({
    required int parentId,
    required bool consent,
  });

  Future<void> updateStage({
    required int parentId,
    required int stageId,
  });
}
