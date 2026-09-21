import 'package:drift/drift.dart';
import 'package:homeo/core/local_db/tables/focus_sessions_table.dart';

/// PRD §16.2 `reflection_entries`. Append-only (PRD §22.2), so no conflict
/// resolution is needed on sync.
///
/// NOTE: PRD §24.3 classifies mood/reflection as High sensitivity
/// (column-level encryption). Local encryption is not wired yet — tracked as
/// follow-up before the first beta build.
@DataClassName('ReflectionEntryRow')
class ReflectionEntries extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text().nullable().references(
    FocusSessions,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get promptKey => text()();
  TextColumn get moodTag => text().nullable()();
  TextColumn get responseText => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
