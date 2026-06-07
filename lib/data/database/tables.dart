import 'package:drift/drift.dart';

@DataClassName('QuadrantRow')
class Quadrants extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get label => text()();
}

@DataClassName('EmotionRow')
class Emotions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get quadrantId => integer().references(Quadrants, #id)();
}

@DataClassName('StageRow')
class Stages extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text().unique()();
  TextColumn get label => text()();
}

@DataClassName('ActivityRow')
class Activities extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get label => text()();
}

@DataClassName('LocationRow')
class Locations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get label => text()();
}

@DataClassName('ParentRow')
class Parents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get firstName => text()();
  TextColumn get babyFirstName => text()();
  DateTimeColumn get babyBirthDate => dateTime()();
  IntColumn get gestationalAgeWeeks => integer()();
  IntColumn get stageId => integer().references(Stages, #id)();
  IntColumn get coparentId =>
      integer().nullable().customConstraint('NULL REFERENCES parents(id)')();
  BoolColumn get sharingConsent =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('EntryRow')
class Entries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get parentId => integer().references(Parents, #id)();
  IntColumn get emotionId => integer().references(Emotions, #id)();
  IntColumn get intensity => integer()
      .customConstraint('NOT NULL CHECK (intensity BETWEEN 1 AND 5)')();
  IntColumn get activityId =>
      integer().nullable().references(Activities, #id)();
  IntColumn get locationId =>
      integer().nullable().references(Locations, #id)();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}
