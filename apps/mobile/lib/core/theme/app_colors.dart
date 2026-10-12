import 'package:flutter/material.dart';

/// Semantic colour set for one brightness. Widgets read it via
/// `AppColors.of(context)` — never hard-code hex values in widgets.
///
/// Values come from the Homeo (P-type) design: `ThemeContext.tsx` LIGHT/DARK.
@immutable
class AppColorSet {
  const AppColorSet({
    required this.canvas,
    required this.surface,
    required this.surfaceAlt,
    required this.surfaceRaised,
    required this.border,
    required this.borderStrong,
    required this.rule,
    required this.ink,
    required this.inkMuted,
    required this.inkSubtle,
    required this.inkFaint,
    required this.primary,
    required this.primaryGlow,
    required this.onPrimary,
    required this.primarySoft,
    required this.onPrimarySoft,
    required this.primaryText,
    required this.accent,
    required this.onAccent,
    required this.accentSoft,
    required this.accentText,
    required this.success,
    required this.successSoft,
    required this.warn,
    required this.warnSoft,
    required this.onWarnSoft,
    required this.danger,
    required this.onDanger,
    required this.dangerSoft,
    required this.onDangerSoft,
    required this.navBg,
    required this.focusCanvas,
    required this.focusSurface,
  });

  // Backgrounds
  final Color canvas;
  final Color surface;
  final Color surfaceAlt;
  final Color surfaceRaised;
  final Color border;
  final Color borderStrong;
  final Color rule;

  // Text
  final Color ink;
  final Color inkMuted;

  /// Hints / placeholders.
  final Color inkSubtle;

  /// Decorative only (disabled labels, inactive icons) — not for body text.
  final Color inkFaint;

  // Brand
  final Color primary;

  /// Second stop of the primary gradient.
  final Color primaryGlow;
  final Color onPrimary;
  final Color primarySoft;
  final Color onPrimarySoft;
  final Color primaryText;

  // Accent — reward / streak
  final Color accent;
  final Color onAccent;
  final Color accentSoft;
  final Color accentText;

  // Semantic
  final Color success;
  final Color successSoft;
  final Color warn;
  final Color warnSoft;
  final Color onWarnSoft;
  final Color danger;
  final Color onDanger;
  final Color dangerSoft;
  final Color onDangerSoft;

  final Color navBg;

  // Immersive focus screen (dark in both themes)
  final Color focusCanvas;
  final Color focusSurface;
}

abstract final class AppColors {
  // ── Brand tokens (design: index.css / ThemeContext) ─────────────────────
  static const Color brandPrimary = Color(0xFF6C63E0);
  static const Color brandAccent = Color(0xFFFF9F7A);
  static const Color brandDanger = Color(0xFFC1443B);

  /// Friction-gate backdrop.
  static const Color scrim = Color(0xB81C1635);

  // ── Raw palette (kept for existing references) ─────────────────────────
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray900 = Color(0xFF111827);

  static const Color indigo100 = Color(0xFFE0E7FF);
  static const Color indigo200 = Color(0xFFC7D2FE);
  static const Color indigo300 = Color(0xFFA5B4FC);
  static const Color indigo950 = Color(0xFF1E1B4B);

  static const Color amber100 = Color(0xFFFEF3C7);
  static const Color amber400 = Color(0xFFFBBF24);
  static const Color amber700 = Color(0xFFB45309);

  static const Color green100 = Color(0xFFDCFCE7);
  static const Color green400 = Color(0xFF4ADE80);
  static const Color green700 = Color(0xFF15803D);

  static const Color red100 = Color(0xFFFEE2E2);
  static const Color red300 = Color(0xFFFCA5A5);
  static const Color red400 = Color(0xFFF87171);
  static const Color red700 = Color(0xFFB91C1C);

  // ── Light ──────────────────────────────────────────────────────────────
  static const AppColorSet light = AppColorSet(
    canvas: Color(0xFFFDFBF6),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFF5F4FE),
    surfaceRaised: Color(0xFFFFFFFF),
    border: Color(0xFFE8E4F5),
    borderStrong: Color(0xFFC5C1D8),
    rule: Color(0xFFF2F0FA),
    ink: Color(0xFF1C1635),
    inkMuted: Color(0xFF716D96),
    inkSubtle: Color(0xFF78749C),
    inkFaint: Color(0xFFC5C1D8),
    primary: Color(0xFF6C63E0),
    primaryGlow: Color(0xFF8B7FF0),
    onPrimary: Colors.white,
    primarySoft: Color(0xFFEAE8FB),
    onPrimarySoft: Color(0xFF5550C8),
    primaryText: Color(0xFF6C63E0),
    accent: Color(0xFFFF9F7A),
    onAccent: Color(0xFF1C1635),
    accentSoft: Color(0xFFFFE8DF),
    accentText: Color(0xFFB8481F),
    success: Color(0xFF5CB88A),
    successSoft: Color(0xFFDFF3EB),
    warn: Color(0xFFF0A500),
    warnSoft: Color(0xFFFFF3CC),
    onWarnSoft: Color(0xFF8A5C00),
    danger: Color(0xFFC1443B),
    onDanger: Colors.white,
    dangerSoft: Color(0xFFFDECEA),
    onDangerSoft: Color(0xFFB03030),
    navBg: Color(0xFFFFFFFF),
    focusCanvas: Color(0xFF1C1635),
    focusSurface: Color(0x14FFFFFF), // white @ 8%
  );

  // ── Dark ───────────────────────────────────────────────────────────────
  static const AppColorSet dark = AppColorSet(
    canvas: Color(0xFF0D0C18),
    surface: Color(0xFF17162A),
    surfaceAlt: Color(0xFF1F1E35),
    surfaceRaised: Color(0xFF252342),
    border: Color(0xFF2A2740),
    borderStrong: Color(0xFF4E4B6A),
    rule: Color(0xFF1E1C30),
    ink: Color(0xFFEDEAF8),
    inkMuted: Color(0xFF9D9ABE),
    inkSubtle: Color(0xFF8380A5),
    inkFaint: Color(0xFF4E4B6A),
    primary: Color(0xFF8078F2),
    primaryGlow: Color(0xFFA39CF7),
    onPrimary: Color(0xFF0D0C18),
    primarySoft: Color(0xFF252248),
    onPrimarySoft: Color(0xFF9D97F5),
    primaryText: Color(0xFF9D97F5),
    accent: Color(0xFFFF9F7A),
    onAccent: Color(0xFF1C1635),
    accentSoft: Color(0xFF3D2520),
    accentText: Color(0xFFFF9F7A),
    success: Color(0xFF5CB88A),
    successSoft: Color(0xFF1A3328),
    warn: Color(0xFFF0A500),
    warnSoft: Color(0xFF2D2210),
    onWarnSoft: Color(0xFFF0C060),
    danger: Color(0xFFE06060),
    onDanger: Color(0xFF3D0A0A),
    dangerSoft: Color(0xFF3D1C1C),
    onDangerSoft: Color(0xFFF0A0A0),
    navBg: Color(0xFF100F1E),
    focusCanvas: Color(0xFF1C1635),
    focusSurface: Color(0x14FFFFFF),
  );

  static AppColorSet of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;
}
