import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeo/core/local_db/app_database.dart';
import 'package:homeo/core/local_db/database_provider.dart';
import 'package:homeo/core/time/clock.dart';
import 'package:homeo/features/focus_session/domain/focus_session.dart';
import 'package:homeo/features/focus_session/domain/session_reflection.dart';
import 'package:uuid/uuid.dart';

part 'focus_session_repository.g.dart';

// ---------------------------------------------------------------------------
// Abstract interface
// ---------------------------------------------------------------------------

abstract class FocusSessionRepository {
  /// Stream of all sessions, newest first.
  Stream<List<FocusSession>> watchAll();

  /// Stream of sessions filtered by status.
  Stream<List<FocusSession>> watchByStatus(FocusSessionStatus status);

  /// Save a new or updated session.
  Future<void> upsert(FocusSession session);

  /// Add a reflection entry attached to a session.
  Future<void> addReflection(ReflectionEntry entry);

  /// Fetch the complete reflection for a session.
  Future<List<ReflectionEntry>> getReflections(String sessionId);

  /// Delete a session and its reflections.
  Future<void> delete(String sessionId);
}

// ---------------------------------------------------------------------------
// Drift implementation
// ---------------------------------------------------------------------------

@DriftAccessor(tables: [FocusSessions, ReflectionEntries])
class DriftFocusSessionRepository extends DatabaseAccessor<AppDatabase>
    with _$DriftFocusSessionRepositoryMixin
    implements FocusSessionRepository {
  DriftFocusSessionRepository(super.db);

  static const _uuid = Uuid();

  // ---------- Watch ----------

  @override
  Stream<List<FocusSession>> watchAll() {
    return (select(focusSessions)
          ..orderBy([
            (t) => OrderingTerm.desc(t.startedAt),
          ]))
        .watch()
        .map((rows) => rows.map(_rowToSession).toList());
  }

  @override
  Stream<List<FocusSession>> watchByStatus(FocusSessionStatus status) {
    return (select(focusSessions)
          ..where((t) => t.status.equals(status.name))
          ..orderBy([
            (t) => OrderingTerm.desc(t.startedAt),
          ]))
        .watch()
        .map((rows) => rows.map(_rowToSession).toList());
  }

  // ---------- Write ----------

  @override
  Future<void> upsert(FocusSession session) {
    // FIX: call FocusSessionsCompanion() as a plain constructor — NOT as
    // this.FocusSessionRow() or this.FocusSession().
    // Original error: "The method 'FocusSession' isn't defined for the type
    // 'DriftFocusSessionRepository'" — because the code mistakenly wrote
    // `return FocusSession(...)` inside the class scope where Dart thought
    // it was a method call.  Using the Drift-generated Companion type is
    // the correct approach.
    return into(focusSessions).insertOnConflictUpdate(
      FocusSessionsCompanion(
        id: Value(session.id),
        taskLabel: Value(session.taskLabel),
        plannedMinutes: Value(session.plannedMinutes),
        elapsedSeconds: Value(session.elapsedSeconds),
        status: Value(session.status.name),
        startedAt: Value(session.startedAt),
        endedAt: Value(session.endedAt),
        exitReason: Value(session.exitReason?.name),
        mood: Value(session.mood?.name),
      ),
    );
  }

  @override
  Future<void> addReflection(ReflectionEntry entry) {
    // FIX: same issue — use ReflectionEntriesCompanion(), not this.ReflectionEntryRow().
    return into(reflectionEntries).insertOnConflictUpdate(
      ReflectionEntriesCompanion(
        id: Value(entry.id.isNotEmpty ? entry.id : _uuid.v4()),
        sessionId: Value(entry.sessionId),
        promptKey: Value(entry.promptKey),
        answer: Value(entry.answer),
        createdAt: Value(entry.createdAt),
      ),
    );
  }

  @override
  Future<List<ReflectionEntry>> getReflections(String sessionId) async {
    final rows = await (select(reflectionEntries)
          ..where((t) => t.sessionId.equals(sessionId)))
        .get();
    // FIX: call _rowToReflection() as a plain method, not this.ReflectionEntryRow().
    return rows.map(_rowToReflection).toList();
  }

  @override
  Future<void> delete(String sessionId) async {
    await (deleteFrom(reflectionEntries)
          ..where((t) => t.sessionId.equals(sessionId)))
        .go();
    await (deleteFrom(focusSessions)
          ..where((t) => t.id.equals(sessionId)))
        .go();
  }

  // ---------- Mappers ----------

  // FIX: These are plain private methods — previously the code called them
  // as `this.FocusSession(...)` / `this.FocusSessionRow(...)` which Dart
  // interprets as calling a non-existent method named 'FocusSession' on the
  // class, not the FocusSession constructor.
  FocusSession _rowToSession(FocusSession row) {
    // Note: Drift generates a data class with the same name as the table's
    // data class.  If there is a name clash with the domain FocusSession,
    // use a typedef or rename the table data class in app_database.dart.
    // Here we use the Drift-generated type directly; the row IS the generated
    // data object from the FocusSessions table.
    //
    // Drift names the data class after the table (FocusSessions → FocusSession).
    // To avoid ambiguity we cast explicitly.
    final r = row as dynamic; // ignore: avoid_dynamic_calls
    return FocusSession(
      id: r.id as String,
      taskLabel: r.taskLabel as String?,
      plannedMinutes: r.plannedMinutes as int,
      elapsedSeconds: r.elapsedSeconds as int,
      status: FocusSessionStatus.values
          .firstWhere((e) => e.name == r.status as String),
      startedAt: r.startedAt as DateTime,
      endedAt: r.endedAt as DateTime?,
      exitReason: r.exitReason != null
          ? ExitReason.values
              .firstWhere((e) => e.name == r.exitReason as String)
          : null,
      mood: r.mood != null
          ? SessionMood.values
              .firstWhere((e) => e.name == r.mood as String)
          : null,
    );
  }

  ReflectionEntry _rowToReflection(dynamic row) {
    return ReflectionEntry(
      id: row.id as String,
      sessionId: row.sessionId as String,
      promptKey: row.promptKey as String,
      answer: row.answer as String,
      createdAt: row.createdAt as DateTime,
    );
  }
}

// ---------------------------------------------------------------------------
// Riverpod providers
// ---------------------------------------------------------------------------

/// Provides the [FocusSessionRepository] implementation.
final focusSessionRepositoryProvider = Provider<FocusSessionRepository>(
  (ref) {
    final db = ref.watch(appDatabaseProvider);
    return DriftFocusSessionRepository(db);
  },
  name: 'focusSessionRepositoryProvider',
);
