import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'seed_data.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Quadrants,
    Emotions,
    Stages,
    Activities,
    Locations,
    Parents,
    Entries,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await seedReferenceData(this);
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await customStatement('DELETE FROM activities');
            await customStatement('DELETE FROM locations');
            await seedActivitiesAndLocations(this);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'dionysus');
}
