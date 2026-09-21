import 'package:drift/drift.dart';

/// PRD §16.2 / §9.3 `distraction_events`: one row per resolved gate.
/// Append-only. `reason_text` is encrypted (PRD §24.3, Medium+).
@DataClassName('DistractionEventRow')
class DistractionEvents extends Table {
  TextColumn get id => text()();
  TextColumn get appPackageId => text()();
  IntColumn get frictionLevel => integer()();
  TextColumn get resolvedAction => text()();
  BoolColumn get duringSession =>
      boolean().withDefault(const Constant(false))();
  TextColumn get reasonText => text().nullable()();
  DateTimeColumn get occurredAt => dateTime()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
