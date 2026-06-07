import '../../domain/entities/activity.dart';
import '../../domain/entities/emotion.dart';
import '../../domain/entities/entry.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/parent.dart';
import '../../domain/entities/quadrant.dart';
import '../../domain/entities/stage.dart';
import '../database/app_database.dart';

extension QuadrantRowMapper on QuadrantRow {
  Quadrant toDomain() => Quadrant(id: id, label: label);
}

extension EmotionRowMapper on EmotionRow {
  Emotion toDomain() => Emotion(id: id, name: name, quadrantId: quadrantId);
}

extension StageRowMapper on StageRow {
  Stage toDomain() => Stage(id: id, code: code, label: label);
}

extension ActivityRowMapper on ActivityRow {
  Activity toDomain() => Activity(id: id, label: label);
}

extension LocationRowMapper on LocationRow {
  Location toDomain() => Location(id: id, label: label);
}

extension ParentRowMapper on ParentRow {
  Parent toDomain() => Parent(
        id: id,
        firstName: firstName,
        babyFirstName: babyFirstName,
        babyBirthDate: babyBirthDate,
        gestationalAgeWeeks: gestationalAgeWeeks,
        stageId: stageId,
        coparentId: coparentId,
        sharingConsent: sharingConsent,
        createdAt: createdAt,
      );
}

extension EntryRowMapper on EntryRow {
  Entry toDomain() => Entry(
        id: id,
        parentId: parentId,
        emotionId: emotionId,
        intensity: intensity,
        activityId: activityId,
        locationId: locationId,
        createdAt: createdAt,
      );
}
