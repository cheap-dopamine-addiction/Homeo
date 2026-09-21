import 'package:homeo/features/focus_session/domain/streak_calculator.dart';
import 'package:homeo/features/focus_session/presentation/providers/focus_session_providers.dart';
import 'package:homeo/features/settings/data/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'streak_recovery_providers.g.dart';

/// A just-ended streak the user has not been through recovery for yet, or
/// null. Stays null until both history and settings have loaded, so the
/// recovery screen can never flash up on a half-loaded app.
@Riverpod(keepAlive: true)
StreakBreak? streakBreak(Ref ref) {
  if (ref.watch(finishedSessionsProvider).value == null) return null;
  final settings = ref.watch(userSettingsProvider).value;
  if (settings == null) return null;

  return StreakCalculator.detectBreak(
    ref.watch(focusStatsProvider).streak,
    acknowledgedRunEnd: settings.streakBreakAckedRunEnd,
  );
}
