// ---------------------------------------------------------------------------
// Enums
// ---------------------------------------------------------------------------

/// How the user chose to end a session early.
enum ExitReason {
  /// The user tapped "I'm done" — intentional finish.
  userEnded,

  /// Something external interrupted the session.
  interrupted,

  /// User simply dismissed / backgrounded without saving.
  dismissed,
}

/// Subjective mood the user reports at the end of a session.
enum SessionMood {
  great,
  good,
  neutral,
  tired,
  distracted,
}

// ---------------------------------------------------------------------------
// Reflection prompt keys
// ---------------------------------------------------------------------------

/// Stable string keys for end-of-session reflection prompts.
///
/// Used as the `promptKey` column in the database so that
/// prompts can be changed without losing historical answers.
abstract class ReflectionPromptKeys {
  ReflectionPromptKeys._();

  static const String whatWentWell = 'what_went_well';
  static const String whatDistracted = 'what_distracted';
  static const String nextSessionGoal = 'next_session_goal';
  static const String overallFeeling = 'overall_feeling';

  static const List<String> all = [
    whatWentWell,
    whatDistracted,
    nextSessionGoal,
    overallFeeling,
  ];
}

// ---------------------------------------------------------------------------
// Value object
// ---------------------------------------------------------------------------

/// A single reflection answer attached to a [FocusSession].
class ReflectionEntry {
  const ReflectionEntry({
    required this.id,
    required this.sessionId,
    required this.promptKey,
    required this.answer,
    required this.createdAt,
  });

  final String id;
  final String sessionId;
  final String promptKey;
  final String answer;
  final DateTime createdAt;

  @override
  String toString() =>
      'ReflectionEntry(promptKey: $promptKey, answer: $answer)';
}
