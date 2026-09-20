import 'package:drift/drift.dart';
import 'package:homeo/core/local_db/app_database.dart';
import 'package:homeo/core/local_db/database_provider.dart';
import 'package:homeo/core/time/clock.dart';
import 'package:homeo/features/focus_session/domain/focus_session.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'focus_session_repository.g.dart';

/// Local-first access to focus sessions. The UI only ever talks to this, and
/// this only ever talks to the local DB — sync is a separate background job
/// that pushes rows whose `synced_at` is null (PRD §21–22).
abstract interface class FocusSessionRepository {
  /// The session that was still running when the app last stopped, if any.
  Future<FocusSession?> findActive();

  /// Insert or fully overwrite a session (keyed by `id`).
  Future<void> upsert(FocusSession session);

  /// Finished (completed + aborted) sessions, newest first.
  Stream<List<FocusSession>> watchFinished();

  /// Pauses already spent on the local calendar day of [day].
  Future<int> pausesUsedOn(DateTime day, {String? excludeSessionId});

  Future<void> saveReflection({
    required String sessionId,
    required String promptKey,
    String? moodTag,
    String? responseText,
  });
}

class DriftFocusSessionRepository implements FocusSessionRepository {
  DriftFocusSessionRepository(this._db, this._clock);

  static const _uuid = Uuid();

  final AppDatabase _db;
  final Clock _clock;

  @override
  Future<FocusSession?> findActive() async {
    final t = _db.focusSessions;
    final row = await (_db.select(t)
          ..where((r) => r.status.equals(FocusSessionStatus.active.name))
          ..orderBy([(r) => OrderingTerm.desc(r.startedAt)])
          ..limit(1))
        .getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  @override
  Future<void> upsert(FocusSession session) {
    // toCompanion(false) keeps explicit NULLs. That matters: when a session
    // resumes, `paused_at` must be written back to NULL — a plain data class
    // (or nullToAbsent = true) would silently skip it.
    return _db
        .into(_db.focusSessions)
        .insertOnConflictUpdate(_toRow(session).toCompanion(false));
  }

  @override
  Stream<List<FocusSession>> watchFinished() {
    final query = _db.select(_db.focusSessions)
      ..where((r) => r.status.isNotValue(FocusSessionStatus.active.name))
      ..orderBy([(r) => OrderingTerm.desc(r.startedAt)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<int> pausesUsedOn(DateTime day, {String? excludeSessionId}) async {
    final t = _db.focusSessions;
    final dayStart = DateTime(day.year, day.month, day.day);
    final dayEnd = DateTime(day.year, day.month, day.day + 1);

    Expression<bool> predicate = t.startedAt.isBiggerOrEqualValue(dayStart) &
        t.startedAt.isSmallerThanValue(dayEnd);
    if (excludeSessionId != null) {
      predicate = predicate & t.id.isNotValue(excludeSessionId);
    }

    final total = t.pauseCount.sum();
    final query = _db.selectOnly(t)
      ..addColumns([total])
      ..where(predicate);
    final row = await query.getSingle();
    return (row.read(total) ?? 0).toInt();
  }

  @override
  Future<void> saveReflection({
    required String sessionId,
    required String promptKey,
    String? moodTag,
    String? responseText,
  }) async {
    await _db.into(_db.reflectionEntries).insert(
          ReflectionEntryRow(
            id: _uuid.v4(),
            sessionId: sessionId,
            promptKey: promptKey,
            moodTag: moodTag,
            responseText: responseText,
            createdAt: _clock.now(),
            syncedAt: null,
          ),
        );
  }

  // ── Mapping ──────────────────────────────────────────────────────────────

  FocusSession _toDomain(FocusSessionRow row) {
    return FocusSession(
      id: row.id,
      intention: row.intention,
      plannedDuration: Duration(seconds: row.plannedDurationSec),
      actualDuration: Duration(seconds: row.actualDurationSec),
      status: FocusSessionStatus.values.byName(row.status),
      startedAt: row.startedAt,
      endedAt: row.endedAt,
      pauseCount: row.pauseCount,
      pausedTotal: Duration(seconds: row.pausedTotalSec),
      pausedAt: row.pausedAt,
    );
  }

  FocusSessionRow _toRow(FocusSession s) {
    return FocusSessionRow(
      id: s.id,
      intention: s.intention,
      plannedDurationSec: s.plannedDuration.inSeconds,
      actualDurationSec: s.actualDuration.inSeconds,
      status: s.status.name,
      startedAt: s.startedAt,
      endedAt: s.endedAt,
      pauseCount: s.pauseCount,
      pausedTotalSec: s.pausedTotal.inSeconds,
      pausedAt: s.pausedAt,
      syncedAt: null, // any local change makes the row dirty again
      updatedAt: _clock.now(),
    );
  }
}

@Riverpod(keepAlive: true)
FocusSessionRepository focusSessionRepository(Ref ref) {
  return DriftFocusSessionRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(clockProvider),
  );
}
