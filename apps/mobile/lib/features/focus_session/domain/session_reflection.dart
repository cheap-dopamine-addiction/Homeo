/// Post-session mood (PRD §9.1 "Reflection"). Stored as `mood_tag`.
enum SessionMood { hard, okay, good, great }

/// Optional reason given at the exit gate. Stored as `response_text`.
enum ExitReason { emergency, tired, distracted, other }

/// Optional reason on the streak-recovery screen. Stored as `response_text`.
enum StreakBreakReason { tired, emergency, motivation, other }

/// `reflection_entries.prompt_key` values.
abstract final class ReflectionPromptKeys {
  static const String sessionMood = 'session_mood';
  static const String exitReason = 'session_exit_reason';
  static const String streakBreakReason = 'streak_break_reason';
}
