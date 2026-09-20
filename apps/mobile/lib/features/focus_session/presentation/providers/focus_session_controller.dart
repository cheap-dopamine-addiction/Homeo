import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeo/core/time/clock.dart';
import 'package:homeo/features/focus_session/data/focus_session_repository.dart';
import 'package:homeo/features/focus_session/domain/focus_rules.dart';
import 'package:homeo/features/focus_session/domain/focus_session.dart';
import 'package:homeo/features/focus_session/domain/focus_session_state.dart';
import 'package:homeo/features/focus_session/domain/session_reflection.dart';
import 'package:uuid/uuid.dart';

part 'focus_session_controller.g.dart';

// ---------------------------------------------------------------------------
// Controller
// ---------------------------------------------------------------------------

// FIX 1: The original file declared the class without the correct Riverpod
// code-gen annotation, so `state`, `ref`, and `build` were all undefined.
// The class must extend `Notifier<FocusSessionState>` (from riverpod_annotation)
// and be annotated with @riverpod so the generator creates the provider.

@riverpod
class FocusSessionController extends _$FocusSessionController {
  static const _uuid = Uuid();
  Timer? _ticker;

  // FIX 2: `build()` is the correct override — NOT a method named `build`
  // with @override on a non-overriding member.  The generator expects this
  // exact signature.
  @override
  FocusSessionState build() {
    // Clean up the ticker if the provider is disposed.
    ref.onDispose(_stopTimer);
    return const FocusIdle();
  }

  // ---------- User actions ----------

  /// Move from [FocusIdle] → [FocusSetup].
  void startSetup() {
    if (state is! FocusIdle) return;
    state = const FocusSetup();
  }

  /// Update configuration while in [FocusSetup].
  void updateSetup({int? plannedMinutes, String? taskLabel}) {
    if (state is! FocusSetup) return;
    final setup = state as FocusSetup;
    state = setup.copyWith(
      plannedMinutes: plannedMinutes,
      taskLabel: taskLabel,
    );
  }

  /// Cancel setup and go back to [FocusIdle].
  void cancelSetup() {
    if (state is! FocusSetup) return;
    // FIX 3: call FocusIdle() as a plain CONSTRUCTOR, not this.FocusIdle()
    state = const FocusIdle();
  }

  /// [FocusSetup] → [FocusRunning]: create the session and start the timer.
  Future<void> beginSession() async {
    if (state is! FocusSetup) return;
    final setup = state as FocusSetup;

    if (!FocusRules.isValidDuration(setup.plannedMinutes)) return;

    final clock = ref.read(clockProvider);
    final repo = ref.read(focusSessionRepositoryProvider);

    // FIX 4: `FocusSession(...)` is a domain constructor call — not a method
    // on this class.  The original error was caused by writing `FocusSession(`
    // inside the class body where Dart resolved it as a method call.
    final session = FocusSession(
      id: _uuid.v4(),
      plannedMinutes: setup.plannedMinutes,
      taskLabel: setup.taskLabel,
      startedAt: clock.now(),
      status: FocusSessionStatus.running,
    );

    await repo.upsert(session);

    // FIX 5: `FocusRunning(...)` is a state constructor, not a method.
    state = FocusRunning(session: session, elapsedSeconds: 0);
    _startTimer();
  }

  /// Pause / resume the running timer.
  void togglePause() {
    if (state is! FocusRunning) return;
    final running = state as FocusRunning;
    if (running.isPaused) {
      _startTimer();
    } else {
      _stopTimer();
    }
    state = running.copyWith(isPaused: !running.isPaused);
  }

  /// User explicitly ends the session before the timer completes.
  Future<void> endSessionEarly({
    ExitReason reason = ExitReason.userEnded,
  }) async {
    if (state is! FocusRunning) return;
    _stopTimer();
    final running = state as FocusRunning;
    final clock = ref.read(clockProvider);

    final isCompleted = FocusRules.isCompleted(
      elapsedSeconds: running.elapsedSeconds,
      plannedSeconds: running.session.plannedMinutes * 60,
    );

    final updatedSession = running.session.copyWith(
      elapsedSeconds: running.elapsedSeconds,
      endedAt: clock.now(),
      status: isCompleted
          ? FocusSessionStatus.completed
          : FocusSessionStatus.abandoned,
      exitReason: isCompleted ? null : reason,
    );

    final repo = ref.read(focusSessionRepositoryProvider);
    await repo.upsert(updatedSession);

    // FIX 6: FocusSummary(...) is a state constructor.
    state = FocusSummary(session: updatedSession);
  }

  /// Submit a reflection answer for the current summary.
  Future<void> submitReflection({
    required String promptKey,
    required String answer,
  }) async {
    if (state is! FocusSummary) return;
    final summary = state as FocusSummary;

    final entry = ReflectionEntry(
      id: _uuid.v4(),
      sessionId: summary.session.id,
      promptKey: promptKey,
      answer: answer,
      createdAt: DateTime.now(),
    );

    final repo = ref.read(focusSessionRepositoryProvider);
    await repo.addReflection(entry);

    state = FocusSummary(
      session: summary.session,
      reflections: [...summary.reflections, entry],
    );
  }

  /// Dismiss the summary and return to [FocusIdle].
  void dismissSummary() {
    if (state is! FocusSummary) return;
    state = const FocusIdle();
  }

  /// Reset to [FocusIdle] from any state (e.g. on auth sign-out).
  void reset() {
    _stopTimer();
    state = const FocusIdle();
  }

  // ---------- Timer internals ----------

  void _startTimer() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _stopTimer() {
    _ticker?.cancel();
    _ticker = null;
  }

  void _tick() {
    if (state is! FocusRunning) {
      _stopTimer();
      return;
    }
    final running = state as FocusRunning;
    if (running.isPaused) return;

    final newElapsed = running.elapsedSeconds + 1;
    final plannedSeconds = running.session.plannedMinutes * 60;

    if (newElapsed >= plannedSeconds) {
      // Timer complete — auto-finish.
      _stopTimer();
      _onTimerComplete(running, newElapsed);
      return;
    }

    state = running.copyWith(elapsedSeconds: newElapsed);
  }

  Future<void> _onTimerComplete(FocusRunning running, int elapsed) async {
    final clock = ref.read(clockProvider);
    final repo = ref.read(focusSessionRepositoryProvider);

    final completed = running.session.copyWith(
      elapsedSeconds: elapsed,
      endedAt: clock.now(),
      status: FocusSessionStatus.completed,
    );

    await repo.upsert(completed);
    state = FocusSummary(session: completed);
  }
}

// ---------------------------------------------------------------------------
// Additional provider: focusImmersiveProvider
// ---------------------------------------------------------------------------
// FIX 7: app_shell.dart referenced `focusImmersiveProvider` which was never
// declared anywhere.  It is a derived provider that returns true when the
// focus timer is actively running (used to hide the bottom nav bar).

/// Returns `true` while the focus timer is actively running (not paused,
/// not in setup, not in summary).  Used by [AppShell] to hide the bottom
/// navigation bar during an immersive focus session.
@riverpod
bool focusImmersive(Ref ref) {
  final state = ref.watch(focusSessionControllerProvider);
  return state is FocusRunning && !state.isPaused;
}
