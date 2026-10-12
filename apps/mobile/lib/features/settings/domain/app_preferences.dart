import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show ThemeMode;

/// Lightweight, non-sensitive UI preferences (theme, notification toggles,
/// quiet hours, onboarding flag). Stored as one JSON blob in
/// `shared_preferences`. Anything sensitive stays in the encrypted DB.
@immutable
class AppPreferences {
  const AppPreferences({
    this.loaded = false,
    this.onboardingDone = false,
    this.onboardingGoal = '',
    this.onboardingTriggers = const <String>[],
    this.themeMode = 'auto',
    this.sessionReminder = true,
    this.sessionComplete = true,
    this.partnerNotif = false,
    this.quietEnabled = true,
    this.quietStart = '22:00',
    this.quietEnd = '08:00',
    this.quietFocus = true,
    this.quietOverride = true,
    this.quietAi = false,
    this.profileName = '',
    this.email = '',
    this.phone = '',
  });

  /// False until `PreferencesController.load` finished (router waits on it).
  final bool loaded;
  final bool onboardingDone;
  final String onboardingGoal;
  final List<String> onboardingTriggers;

  /// `light` | `dark` | `auto` (design: ThemeContext `ThemeMode`).
  final String themeMode;

  final bool sessionReminder;
  final bool sessionComplete;
  final bool partnerNotif;

  final bool quietEnabled;
  final String quietStart;
  final String quietEnd;
  final bool quietFocus;
  final bool quietOverride;
  final bool quietAi;

  final String profileName;
  final String email;
  final String phone;

  ThemeMode get flutterThemeMode => switch (themeMode) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };

  AppPreferences copyWith({
    bool? loaded,
    bool? onboardingDone,
    String? onboardingGoal,
    List<String>? onboardingTriggers,
    String? themeMode,
    bool? sessionReminder,
    bool? sessionComplete,
    bool? partnerNotif,
    bool? quietEnabled,
    String? quietStart,
    String? quietEnd,
    bool? quietFocus,
    bool? quietOverride,
    bool? quietAi,
    String? profileName,
    String? email,
    String? phone,
  }) {
    return AppPreferences(
      loaded: loaded ?? this.loaded,
      onboardingDone: onboardingDone ?? this.onboardingDone,
      onboardingGoal: onboardingGoal ?? this.onboardingGoal,
      onboardingTriggers: onboardingTriggers ?? this.onboardingTriggers,
      themeMode: themeMode ?? this.themeMode,
      sessionReminder: sessionReminder ?? this.sessionReminder,
      sessionComplete: sessionComplete ?? this.sessionComplete,
      partnerNotif: partnerNotif ?? this.partnerNotif,
      quietEnabled: quietEnabled ?? this.quietEnabled,
      quietStart: quietStart ?? this.quietStart,
      quietEnd: quietEnd ?? this.quietEnd,
      quietFocus: quietFocus ?? this.quietFocus,
      quietOverride: quietOverride ?? this.quietOverride,
      quietAi: quietAi ?? this.quietAi,
      profileName: profileName ?? this.profileName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  Map<String, Object?> toJson() => {
    'onboardingDone': onboardingDone,
    'onboardingGoal': onboardingGoal,
    'onboardingTriggers': onboardingTriggers,
    'themeMode': themeMode,
    'sessionReminder': sessionReminder,
    'sessionComplete': sessionComplete,
    'partnerNotif': partnerNotif,
    'quietEnabled': quietEnabled,
    'quietStart': quietStart,
    'quietEnd': quietEnd,
    'quietFocus': quietFocus,
    'quietOverride': quietOverride,
    'quietAi': quietAi,
    'profileName': profileName,
    'email': email,
    'phone': phone,
  };

  factory AppPreferences.fromJson(Map<String, Object?> json) {
    const d = AppPreferences();
    bool b(String k, bool def) => json[k] is bool ? json[k]! as bool : def;
    String s(String k, String def) =>
        json[k] is String ? json[k]! as String : def;
    final triggers = json['onboardingTriggers'];
    final theme = s('themeMode', d.themeMode);
    return AppPreferences(
      onboardingDone: b('onboardingDone', d.onboardingDone),
      onboardingGoal: s('onboardingGoal', d.onboardingGoal),
      onboardingTriggers: triggers is List
          ? [for (final t in triggers) t.toString()]
          : d.onboardingTriggers,
      themeMode: const {'light', 'dark', 'auto'}.contains(theme)
          ? theme
          : d.themeMode,
      sessionReminder: b('sessionReminder', d.sessionReminder),
      sessionComplete: b('sessionComplete', d.sessionComplete),
      partnerNotif: b('partnerNotif', d.partnerNotif),
      quietEnabled: b('quietEnabled', d.quietEnabled),
      quietStart: s('quietStart', d.quietStart),
      quietEnd: s('quietEnd', d.quietEnd),
      quietFocus: b('quietFocus', d.quietFocus),
      quietOverride: b('quietOverride', d.quietOverride),
      quietAi: b('quietAi', d.quietAi),
      profileName: s('profileName', d.profileName),
      email: s('email', d.email),
      phone: s('phone', d.phone),
    );
  }
}
