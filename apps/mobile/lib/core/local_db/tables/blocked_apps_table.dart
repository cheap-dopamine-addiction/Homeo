import 'package:drift/drift.dart';

/// PRD §16.2 `blocked_apps`. A row = the app is on the watch list.
/// `friction_level` stores the level's code (0–4).
@DataClassName('BlockedAppRow')
class BlockedApps extends Table {
  TextColumn get appPackageId => text()();
  IntColumn get frictionLevel => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {appPackageId};
}
