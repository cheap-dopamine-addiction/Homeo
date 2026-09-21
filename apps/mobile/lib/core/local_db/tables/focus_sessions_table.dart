import 'package:drift/drift.dart';

/// PRD §16.2 `focus_sessions`, adapted for the local (single-user) DB.
///
/// * `id` is the client-generated UUID — it doubles as `local_id` for sync
///   idempotency (PRD §22.4).
/// * `status` is stored as text (`active | completed | aborted`) so core/ does
///   not depend on feature enums; the repository maps it.
/// * `paused_at` / `paused_total_sec` / `pause_count` let an in-flight session
///   survive the OS killing the app.
@DataClassName('FocusSessionRow')
@TableIndex(name: 'idx_focus_sessions_started_at', columns: {#startedAt})
class FocusSessions extends Table {
  TextColumn get id => text()();
  TextColumn get intention => text().withDefault(const Constant(''))();
  IntColumn get plannedDurationSec => integer()();
  IntColumn get actualDurationSec => integer().withDefault(const Constant(0))();
  TextColumn get status => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  IntColumn get pauseCount => integer().withDefault(const Constant(0))();
  IntColumn get pausedTotalSec => integer().withDefault(const Constant(0))();
  DateTimeColumn get pausedAt => dateTime().nullable()();

  /// Delta-sync bookkeeping (PRD §22): null `syncedAt` = dirty.
  DateTimeColumn get syncedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
