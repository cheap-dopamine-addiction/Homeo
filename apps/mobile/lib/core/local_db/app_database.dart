import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

// ---------------------------------------------------------------------------
// Table definitions
// ---------------------------------------------------------------------------

/// Persisted row for a single focus session.
class FocusSessions extends Table {
  TextColumn get id => text()();
  TextColumn get taskLabel => text().nullable()();
  IntColumn get plannedMinutes => integer()();
  IntColumn get elapsedSeconds => integer().withDefault(const Constant(0))();
  TextColumn get status => text()(); // matches FocusSessionStatus.name
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  TextColumn get exitReason => text().nullable()();
  TextColumn get mood => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Persisted row for an end-of-session reflection entry.
class ReflectionEntries extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text().references(FocusSessions, #id)();
  TextColumn get promptKey => text()();
  TextColumn get answer => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// Database
// ---------------------------------------------------------------------------

@DriftDatabase(tables: [FocusSessions, ReflectionEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Used in tests to pass an in-memory database.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          // Add migration steps here as schemaVersion increases.
        },
      );
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'homeo_db');
}
