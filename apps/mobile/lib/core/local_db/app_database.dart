import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
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

  // BUG FIX: without `web:`, driftDatabase() has nothing to open the
  // database with on Flutter Web — it silently fails to connect, and every
  // `await` on a query (session start, friction settings, streak, ...)
  // hangs or throws forever. This is why "เริ่ม Session" stayed stuck
  // disabled and the Friction settings page rendered a blank grey box.
  //
  // Fixing the Dart side is only half the fix — you still need to put the
  // two files below in `web/` (see DEBUG_REPORT.md §"ขั้นที่ 7" for exact
  // download links), matching your resolved `sqlite3`/`drift` versions in
  // pubspec.lock:
  //   web/sqlite3.wasm
  //   web/drift_worker.js
  AppDatabase.open()
    : super(
        driftDatabase(
          name: 'homeo',
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
            onResult: (result) {
              if (kDebugMode && result.missingFeatures.isNotEmpty) {
                debugPrint(
                  'drift: using ${result.chosenImplementation} — browser is '
                  'missing ${result.missingFeatures} (falls back '
                  'automatically, just slower/less durable storage)',
                );
              }
            },
          ),
        ),
      );

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
