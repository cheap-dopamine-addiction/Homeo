import 'package:flutter/foundation.dart';
import 'package:homeo/features/friction/domain/friction_level.dart';
import 'package:homeo/features/friction/domain/friction_rules.dart';

@immutable
class UserSettings {
  const UserSettings({
    this.defaultFrictionLevel = FrictionLevel.micro,
    this.emergencyLimitPerMonth = FrictionRules.emergencyDefaultPerMonth,
    this.streakBreakAckedRunEnd,
  });

  static const UserSettings defaults = UserSettings();

  final FrictionLevel defaultFrictionLevel;
  final int emergencyLimitPerMonth;
  final DateTime? streakBreakAckedRunEnd;

  UserSettings copyWith({
    FrictionLevel? defaultFrictionLevel,
    int? emergencyLimitPerMonth,
    DateTime? streakBreakAckedRunEnd,
  }) {
    return UserSettings(
      defaultFrictionLevel: defaultFrictionLevel ?? this.defaultFrictionLevel,
      emergencyLimitPerMonth:
          emergencyLimitPerMonth ?? this.emergencyLimitPerMonth,
      streakBreakAckedRunEnd:
          streakBreakAckedRunEnd ?? this.streakBreakAckedRunEnd,
    );
  }
}
