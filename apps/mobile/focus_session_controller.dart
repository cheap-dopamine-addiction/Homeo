import 'dart:async';

import 'package:homeo/core/time/clock.dart';
import 'package:homeo/features/focus_session/data/focus_session_repository.dart';
import 'package:homeo/features/focus_session/domain/focus_rules.dart';
import 'package:homeo/features/focus_session/domain/focus_session.dart';
import 'package:homeo/features/focus_session/domain/focus_session_state.dart';
import 'package:homeo/features/focus_session/domain/session_reflection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'focus_session_controller.g.dart';

enum PauseOutcome { paused, limitReached, ignored }

/// Owns the whole session lifecycle: setup → running/paused → summary → idle.
///
/// * keepAlive: switching tabs must never stop the timer.
/// * The countdown is *derived* from timestamps (see [FocusSession]); the
///   ticker only decides when to re-render.
/// * State changes happen synchronously before any `await`, so double taps
///   cannot start/finish a session twice.
@Riverpod(keepAlive: true)
class FocusSessionController extends _$FocusSessionController {
  static const _uuid = Uuid();
  static const _tickInterval = Duration(milliseconds: 250);

  Timer? _ticker;
  bool _starting = false;

  FocusSessionRepository get _repo => ref.read(focusSessionRepositoryProvider);
  Clock get _clock => ref.read(clockProvider);

  @override
  FocusSessionState build() {
    ref.onDispose(_stopTicker);
    unawaited(_restoreActiveSession());
    return const FocusIdle();
  }

  // ── Setup ────────────────────────────────────────────────────────────────

  void openSetup() {
    if (state is FocusIdle) state = const FocusSetup();
  }

  void closeSetup() {
    if (state is FocusSetup) state = const FocusIdle();
  }

  Future<void> start({
    required Duration duration,
    required String intention,
  }) async {
    if (_starting || state is! FocusSetup) return;
    if (duration < FocusRules.minDuration) return;

    _starting = true;
    try {
      final now = _clock.now();
      final pausesBefore = await _repo.pausesUsedOn(now);
      final session = FocusSession(
        id: _uuid.v4(),
        intention: intention.trim(),
        plannedDuration: duration,
        startedAt: now,
      );
      await _repo.upsert(session); // durable before the UI says "running"
      if (!ref.mounted) return;

      state = FocusRunning(
        session: session,
        now: now,
        pausesUsedBefore: pausesBefore,
      );
      _startTicker();
    } finally {
      _starting = false;
    }
  }

  // ── Running ──────────────────────────────────────────────────────────────

  /// Synchronous on purpose: the caller needs the outcome immediately to show
  /// the pause-limit sheet.
  PauseOutcome pause() {
    final current = state;
    if (current is! FocusRunning || current.isPaused) return PauseOutcome.ignored;
    if (!current.canPause) return PauseOutcome.limitReached;

    final now = _clock.now();
    final paused = current.session.paused(now);
    _stopTicker();
    state = current.copyWith(session: paused, now: now);
    unawaited(_repo.upsert(paused));
    return PauseOutcome.paused;
  }

  void resume() {
    final current = state;
    if (current is! FocusRunning || !current.isPaused) return;

    final now = _clock.now();
    final resumed = current.session.resumed(now);
    state = current.copyWith(session: resumed, now: now);
    _startTicker();
    unawaited(_repo.upsert(resumed));
  }

  /// Called after the exit gate is confirmed.
  Future<void> abort({ExitReason? reason}) {
    return _finish(completed: false, exitReason: reason);
  }

  // ── Summary ──────────────────────────────────────────────────────────────

  Future<void> completeSummary({SessionMood? mood}) async {
    final current = state;
    if (current is! FocusSummary) return;

    state = const FocusIdle();
    if (mood != null) {
      await _repo.saveReflection(
        sessionId: current.session.id,
        promptKey: ReflectionPromptKeys.sessionMood,
        moodTag: mood.name,
      );
    }
  }

  // ── Internals ────────────────────────────────────────────────────────────

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(_tickInterval, (_) => _onTick());
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  void _onTick() {
    final current = state;
    if (current is! FocusRunning || current.isPaused) {
      _stopTicker();
      return;
    }

    final now = _clock.now();
    if (current.session.remainingAt(now) <= Duration.zero) {
      unawaited(_finish(completed: true));
      return;
    }

    // Only re-render when the visible second changes (4 ticks/s → 1 rebuild/s).
    final next = current.copyWith(now: now);
    if (next.remainingSeconds != current.remainingSeconds) state = next;
  }

  Future<void> _finish({required bool completed, ExitReason? exitReason}) async {
    final current = state;
    if (current is! FocusRunning) return;

    _stopTicker();
    final finished = current.session.finished(
      now: _clock.now(),
      completed: completed,
    );
    state = FocusSummary(session: finished); // sync → later calls are no-ops

    await _repo.upsert(finished);
    if (exitReason != null) {
      await _repo.saveReflection(
        sessionId: finished.id,
        promptKey: ReflectionPromptKeys.exitReason,
        responseText: exitReason.name,
      );
    }
  }

  /// If the OS killed the app mid-session, pick the session back up.
  Future<void> _restoreActiveSession() async {
    final active = await _repo.findActive();
    if (!ref.mounted || active == null || state is! FocusIdle) return;

    final pausesBefore = await _repo.pausesUsedOn(
      active.startedAt,
      excludeSessionId: active.id,
    );
    if (!ref.mounted || state is! FocusIdle) return;

    final now = _clock.now();
    state = FocusRunning(
      session: active,
      now: now,
      pausesUsedBefore: pausesBefore,
    );

    if (active.isPaused) return;
    if (active.remainingAt(now) <= Duration.zero) {
      // It ran out while the app was dead → complete it.
      await _finish(completed: true);
    } else {
      _startTicker();
    }
  }
}

/// True while the Focus tab is in a full-screen phase (setup / running /
/// summary). The app shell hides the bottom navigation then.
@riverpod
bool focusImmersive(Ref ref) {
  return ref.watch(
    focusSessionControllerProvider.select((s) => s.phase != FocusPhase.idle),
  );
}
