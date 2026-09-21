import 'package:drift/drift.dart';

/// PRD §16.2 `user_settings` — a single local row (`id = 'local'`).
@DataClassName('UserSettingsRow')
class UserSettingsTable extends Table {
  @override
  String get tableName => 'user_settings';

  TextColumn get id => text().withDefault(const Constant('local'))();
  IntColumn get defaultFrictionLevel =>
      integer().withDefault(const Constant(1))();
  IntColumn get emergencyLimitPerMonth =>
      integer().withDefault(const Constant(3))();

  /// End day of the streak run whose break the user already acknowledged.
  DateTimeColumn get streakBreakAckedRunEnd => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
