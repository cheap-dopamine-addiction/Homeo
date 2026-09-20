import 'package:flutter/material.dart';

/// Holds a pair of light/dark color palettes.
class AppColorSet {
  const AppColorSet({required this.light, required this.dark});

  final AppColors light;
  final AppColors dark;
}

/// All semantic colors for the Homeo app.
class AppColors {
  const AppColors({
    required this.primary,
    required this.primaryVariant,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.error,
    required this.onPrimary,
    required this.onBackground,
    required this.onSurface,
    required this.onError,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    required this.divider,
    required this.shadow,
    required this.focusRing,
    required this.success,
    required this.warning,
  });

  final Color primary;
  final Color primaryVariant;
  final Color secondary;
  final Color background;
  final Color surface;
  final Color error;
  final Color onPrimary;
  final Color onBackground;
  final Color onSurface;
  final Color onError;
  final Color textPrimary;
  final Color textSecondary;
  final Color textDisabled;
  final Color divider;
  final Color shadow;
  final Color focusRing;
  final Color success;
  final Color warning;

  // ---------- Default palettes ----------

  static const AppColors light = AppColors(
    primary: Color(0xFF6C63FF),
    primaryVariant: Color(0xFF4B44CC),
    secondary: Color(0xFF03DAC6),
    background: Color(0xFFF5F5F5),
    surface: Color(0xFFFFFFFF),
    error: Color(0xFFB00020),
    onPrimary: Color(0xFFFFFFFF),
    onBackground: Color(0xFF1C1B1F),
    onSurface: Color(0xFF1C1B1F),
    onError: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF1C1B1F),
    textSecondary: Color(0xFF49454F),
    textDisabled: Color(0xFF1C1B1F60),
    divider: Color(0xFFE0E0E0),
    shadow: Color(0x1A000000),
    focusRing: Color(0xFF6C63FF40),
    success: Color(0xFF388E3C),
    warning: Color(0xFFF57C00),
  );

  static const AppColors dark = AppColors(
    primary: Color(0xFFBB86FC),
    primaryVariant: Color(0xFF3700B3),
    secondary: Color(0xFF03DAC6),
    background: Color(0xFF121212),
    surface: Color(0xFF1E1E1E),
    error: Color(0xFFCF6679),
    onPrimary: Color(0xFF000000),
    onBackground: Color(0xFFE6E1E5),
    onSurface: Color(0xFFE6E1E5),
    onError: Color(0xFF000000),
    textPrimary: Color(0xFFE6E1E5),
    textSecondary: Color(0xFFCAC4D0),
    textDisabled: Color(0xFFE6E1E560),
    divider: Color(0xFF2C2C2C),
    shadow: Color(0x33000000),
    focusRing: Color(0xFFBB86FC40),
    success: Color(0xFF81C784),
    warning: Color(0xFFFFB74D),
  );

  static const AppColorSet palette = AppColorSet(light: light, dark: dark);
}
