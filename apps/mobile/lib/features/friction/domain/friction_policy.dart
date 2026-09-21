import 'package:flutter/foundation.dart';
import 'package:homeo/features/friction/domain/friction_level.dart';
import 'package:homeo/features/friction/domain/friction_rules.dart';

@immutable
class FrictionDecision {
  const FrictionDecision({
    required this.level,
    required this.baseLevel,
    required this.escalatedByBurst,
    required this.duringSession,
    required this.attemptNumberToday,
  });

  /// The level actually applied.
  final FrictionLevel level;

  /// The level configured for the app.
  final FrictionLevel baseLevel;

  final bool escalatedByBurst;
  final bool duringSession;

  /// 1-based: this attempt counts as "time N today".
  final int attemptNumberToday;
}

/// Context-aware escalation (PRD §11.3). Pure, so it can be tested without
/// a device.
///
/// Not implemented yet: protected hours and "de-escalation as reward" — both
/// need data the app does not collect yet (schedules, weekly trends).
abstract final class FrictionPolicy {
  static FrictionDecision resolve({
    required FrictionLevel base,
    required bool sessionRunning,
    required int priorAttemptsInBurstWindow,
    required int priorAttemptsToday,
    required bool partnerAvailable,
  }) {
    var level = base;

    // L3 while a focus session is running (PRD §11.2).
    if (sessionRunning && level.index < FrictionLevel.fullBlock.index) {
      level = FrictionLevel.fullBlock;
    }

    // Burst → one step up, never past L3: L4 is strictly opt-in.
    var escalated = false;
    final attemptsInBurst = priorAttemptsInBurstWindow + 1;
    if (attemptsInBurst >= FrictionRules.burstThreshold &&
        level.index < FrictionLevel.fullBlock.index) {
      level = FrictionLevel.values[level.index + 1];
      escalated = true;
    }

    // L4 without a partner cannot work; fall back to the strongest level
    // the user can still get out of.
    if (level == FrictionLevel.partnerGated && !partnerAvailable) {
      level = FrictionLevel.fullBlock;
    }

    return FrictionDecision(
      level: level,
      baseLevel: base,
      escalatedByBurst: escalated,
      duringSession: sessionRunning,
      attemptNumberToday: priorAttemptsToday + 1,
    );
  }
}
