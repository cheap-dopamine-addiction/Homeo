// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Homeo';

  @override
  String get tabFocus => 'Focus';

  @override
  String get tabVault => 'Vault';

  @override
  String get tabInsights => 'Insights';

  @override
  String get tabAiCoach => 'AI Coach';

  @override
  String get tabSettings => 'Settings';

  @override
  String get comingSoon => 'This section is coming soon';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String streakDays(int count) {
    return '$count-day streak';
  }

  @override
  String streakBest(int count) {
    return 'Best streak: $count';
  }

  @override
  String get streakNone => 'Start a new streak today';

  @override
  String get focusPrompt => 'What is the one thing you want to finish today?';

  @override
  String get focusStartCta => 'Start focus session';

  @override
  String get statFocusToday => 'Focus today';

  @override
  String get statFocusWeek => 'Focus this week';

  @override
  String get statSessionsToday => 'Sessions today';

  @override
  String lastSessionTitle(String duration) {
    return 'Last session: $duration';
  }

  @override
  String get lastSessionNoIntention => 'No intention set';

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String durationHoursOnly(int hours) {
    return '${hours}h';
  }

  @override
  String durationMinutesOnly(int minutes) {
    return '${minutes}m';
  }

  @override
  String durationPresetMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get durationCustom => 'Custom';

  @override
  String get setupTitle => 'Session setup';

  @override
  String get setupClose => 'Close';

  @override
  String get setupDurationLabel => 'Duration';

  @override
  String get setupIntentionLabel => 'Intention for this session';

  @override
  String get setupIntentionHint => 'e.g. Finish the draft of chapter 3';

  @override
  String get setupIntentionHelper => 'Optional — just a reminder for yourself';

  @override
  String setupStartButton(String duration) {
    return 'Start session $duration';
  }

  @override
  String get pickerTitle => 'Set a custom duration';

  @override
  String get pickerConfirm => 'Confirm';

  @override
  String get pickerCancel => 'Cancel';

  @override
  String get activeStatusFocusing => 'Focusing';

  @override
  String get activeStatusPaused => 'Paused';

  @override
  String get activeExit => 'Leave session';

  @override
  String get activeGoalLabel => 'Intention';

  @override
  String get activePause => 'Pause';

  @override
  String get activeResume => 'Resume focus';

  @override
  String activePausesUsed(int used, int total) {
    return 'Pauses today: $used/$total';
  }

  @override
  String activeTimerSemantics(String status, String time) {
    return '$status, $time remaining';
  }

  @override
  String get exitGateTitle => 'Leave this session?';

  @override
  String get exitGateSubtitle =>
      'That is okay — tell us why if you would like to';

  @override
  String get exitReasonEmergency => 'Emergency';

  @override
  String get exitReasonTired => 'Too tired';

  @override
  String get exitReasonDistracted => 'Cannot concentrate';

  @override
  String get exitReasonOther => 'Something else';

  @override
  String get commonBackToFocus => 'Back to focus';

  @override
  String get exitGateLeave => 'Leave session';

  @override
  String exitGateLeaveWait(int seconds) {
    return 'Leave session (${seconds}s)';
  }

  @override
  String pauseLimitTitle(int used, int total) {
    return 'You have used all your pauses today ($used/$total)';
  }

  @override
  String get pauseLimitBody =>
      'Take a slow breath and settle back in.\nYou have done well to get this far.';

  @override
  String get summaryCompletedTitle => 'Well done!';

  @override
  String get summaryAbortedTitle => 'Thanks for trying';

  @override
  String summaryFocused(String duration) {
    return 'You focused for $duration';
  }

  @override
  String get summaryAbortedNote => 'This session ended early';

  @override
  String get summaryMoodQuestion => 'How did the session feel?';

  @override
  String get moodHard => 'Hard';

  @override
  String get moodOkay => 'Okay';

  @override
  String get moodGood => 'Good';

  @override
  String get moodGreat => 'Great';

  @override
  String get summarySave => 'Save and go home';

  @override
  String get summarySkip => 'Skip';

  @override
  String gateAwarenessTitle(String app, int count) {
    return 'Opening $app: time $count today';
  }

  @override
  String get gateMicroTitle => 'Confirm before opening';

  @override
  String gateMicroBody(String app) {
    return 'Are you sure you want to open $app? Take a moment to think it over.';
  }

  @override
  String get gateReflectiveTitle => 'Pause a moment — head back to focus?';

  @override
  String get gateReflectiveBody =>
      'This is time you chose to protect. If you still want in, tell us why.';

  @override
  String get gateReasonLabel => 'Why do you want to open it?';

  @override
  String get gateReasonHint => 'A few words is enough';

  @override
  String get gateReasonRest => 'Want a break';

  @override
  String get gateReasonTask => 'Something to take care of';

  @override
  String get gateBlockTitle => 'This is your focus time';

  @override
  String get gateBlockBody =>
      'Go back to what you set out to do.\nYou can do this.';

  @override
  String get gatePartnerTitle => 'Protected with your partner';

  @override
  String get gatePartnerBody =>
      'This app is set to L4. Opening it needs approval from your Vault Partner.';

  @override
  String get gatePartnerRequest => 'Send override request';

  @override
  String get gatePartnerPending => 'Request sent — waiting for your partner';

  @override
  String gatePartnerCoolingOff(String time) {
    return 'If they do not reply, this unlocks automatically in $time';
  }

  @override
  String get gatePartnerDenied =>
      'Your partner did not approve this time — head back to focus.';

  @override
  String gateOpenApp(String app) {
    return 'Open $app';
  }

  @override
  String gateOpenAppWait(String app, int seconds) {
    return 'Open $app (${seconds}s)';
  }

  @override
  String get gateConfirm => 'Confirm';

  @override
  String gateConfirmWait(int seconds) {
    return 'Confirm ($seconds)';
  }

  @override
  String get gateEscalatedNote =>
      'Raised automatically because of several attempts in a short time';

  @override
  String get gateSessionNote => 'A focus session is running';

  @override
  String get emergencyLink => 'Emergency?';

  @override
  String get emergencyTitle => 'Unblock right now for an emergency?';

  @override
  String emergencyUsage(int used, int max) {
    return 'Emergency used $used/$max times this month';
  }

  @override
  String emergencyBody(int minutes) {
    return 'Using it unblocks everything for $minutes minutes and is logged.';
  }

  @override
  String get emergencyConfirm => 'Use emergency unblock';

  @override
  String get emergencyExhaustedTitle =>
      'You have used all emergency unblocks for this month';

  @override
  String get emergencyExhaustedBody =>
      'If this is a real emergency, call your local emergency number right away.';

  @override
  String emergencyDone(int minutes) {
    return 'Unblocked for $minutes minutes';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsFrictionTile => 'Friction and watched apps';

  @override
  String get settingsFrictionTileSubtitle =>
      'Choose how hard it is to open risky apps';

  @override
  String get frictionScreenTitle => 'Friction';

  @override
  String get frictionDefaultSection => 'Default level';

  @override
  String get frictionAppsSection => 'Apps to watch';

  @override
  String get frictionAppsHint =>
      'Turn an app on to add friction before it opens';

  @override
  String get frictionL0Name => 'L0 — Awareness';

  @override
  String get frictionL0Desc => 'A quiet reminder';

  @override
  String get frictionL1Name => 'L1 — Micro-friction';

  @override
  String get frictionL1Desc => 'Wait a moment, then confirm';

  @override
  String get frictionL2Name => 'L2 — Reflective pause';

  @override
  String get frictionL2Desc => 'Say why before opening';

  @override
  String get frictionL3Name => 'L3 — Full block';

  @override
  String get frictionL3Desc => 'Fully blocked (emergency unblock only)';

  @override
  String get frictionL4Name => 'L4 — Partner-gated';

  @override
  String get frictionL4Desc => 'Needs approval from your partner';

  @override
  String get frictionL4Locked => 'Available once you connect a Vault Partner';

  @override
  String get frictionEmergencySection => 'Emergency';

  @override
  String get frictionDebugSection => 'Test (debug only)';

  @override
  String frictionDebugSimulate(String app) {
    return 'Simulate opening $app';
  }

  @override
  String recoveryTitle(int days) {
    return 'Your streak paused at $days days';
  }

  @override
  String get recoveryBody => 'That is okay — everyone has days like this';

  @override
  String recoveryBest(int best) {
    return 'Your best streak of $best days is still yours';
  }

  @override
  String get recoveryQuestion => 'Tell us what happened, if you would like';

  @override
  String get recoveryReasonTired => 'Too tired';

  @override
  String get recoveryReasonEmergency => 'Something urgent came up';

  @override
  String get recoveryReasonMotivation => 'Low motivation';

  @override
  String get recoveryRestart => 'Start again today';

  @override
  String get recoveryLater => 'Not now';

  @override
  String get alarmTitle => 'Session complete';

  @override
  String alarmBody(String duration) {
    return 'You focused for $duration. Come back for your summary.';
  }

  @override
  String get alarmChannelName => 'Focus session';

  @override
  String get alarmChannelDescription => 'Tells you when a session ends';
}
