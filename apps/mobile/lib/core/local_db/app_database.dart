import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:homeo/core/local_db/tables/blocked_apps_table.dart';
import 'package:homeo/core/local_db/tables/distraction_events_table.dart';
import 'package:homeo/core/local_db/tables/emergency_overrides_table.dart';
import 'package:homeo/core/local_db/tables/focus_sessions_table.dart';
import 'package:homeo/core/local_db/tables/reflection_entries_table.dart';
import 'package:homeo/core/local_db/tables/user_settings_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    FocusSessions,
    ReflectionEntries,
    BlockedApps,
    DistractionEvents,
    UserSettingsTable,
    EmergencyOverrides,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Tests pass `NativeDatabase.memory()` here.
  AppDatabase(super.e);

  AppDatabase.open() : super(driftDatabase(name: 'homeo'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(blockedApps);
        await m.createTable(distractionEvents);
        await m.createTable(userSettingsTable);
        await m.createTable(emergencyOverrides);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
