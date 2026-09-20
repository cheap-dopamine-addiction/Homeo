// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'focus_session_repository.dart';

// ignore_for_file: type=lint
mixin _$DriftFocusSessionRepositoryMixin on DatabaseAccessor<AppDatabase> {
  $FocusSessionsTable get focusSessions => attachedDatabase.focusSessions;
  $ReflectionEntriesTable get reflectionEntries =>
      attachedDatabase.reflectionEntries;
  DriftFocusSessionRepositoryManager get managers =>
      DriftFocusSessionRepositoryManager(this);
}

class DriftFocusSessionRepositoryManager {
  final _$DriftFocusSessionRepositoryMixin _db;
  DriftFocusSessionRepositoryManager(this._db);
  $$FocusSessionsTableTableManager get focusSessions =>
      $$FocusSessionsTableTableManager(_db.attachedDatabase, _db.focusSessions);
  $$ReflectionEntriesTableTableManager get reflectionEntries =>
      $$ReflectionEntriesTableTableManager(
        _db.attachedDatabase,
        _db.reflectionEntries,
      );
}
