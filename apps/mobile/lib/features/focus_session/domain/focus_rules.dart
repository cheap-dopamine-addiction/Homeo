/// Product rules for focus sessions (PRD §9.1). One place to tune them.
abstract final class FocusRules {
  static const List<int> presetMinutes = [25, 45, 60, 90];
  static const Duration defaultDuration = Duration(minutes: 25);
  static const Duration defaultCustomDuration = Duration(minutes: 45);
  static const Duration minDuration = Duration(minutes: 1);

  /// PRD §9.1: pauses are limited *per day* so they cannot become a loophole.
  static const int maxPausesPerDay = 3;

  /// PRD §9.1: leaving early passes a friction gate (reason + countdown).
  static const int exitGateCountdownSeconds = 5;

  static const int maxIntentionLength = 140;

  /// A broken run shorter than this does not trigger the recovery screen —
  /// nobody needs a talk after a 1-day "streak".
  static const int minStreakForRecovery = 2;
}
