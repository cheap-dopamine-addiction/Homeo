import 'package:drift/drift.dart';

/// Append-only log of emergency unblocks (PRD §9.7, §23.4).
/// `partner_notified_at` is filled by the Vault slice when it ships.
@DataClassName('EmergencyOverrideRow')
class EmergencyOverrides extends Table {
  TextColumn get id => text()();
  DateTimeColumn get occurredAt => dateTime()();
  DateTimeColumn get windowEndsAt => dateTime()();
  DateTimeColumn get partnerNotifiedAt => dateTime().nullable()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
