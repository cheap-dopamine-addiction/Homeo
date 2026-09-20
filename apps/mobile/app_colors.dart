import 'package:flutter/material.dart';

/// Semantic colour set for one brightness. Widgets read it via
/// `AppColors.of(context)` — never hard-code hex values in widgets.
@immutable
class AppColorSet {
  const AppColorSet({
    required this.canvas,
    required this.surface,
    required this.surfaceAlt,
    required this.border,
    required this.borderStrong,
    required this.ink,
    required this.inkMuted,
    required this.inkSubtle,
    required this.primary,
    required this.onPrimary,
    required this.primarySoft,
    required this.onPrimarySoft,
    required this.accent,
    required this.onAccent,
    required this.accentSoft,
    required this.accentText,
    required this.success,
    required this.successSoft,
    required this.danger,
    required this.onDanger,
    required this.dangerSoft,
    required this.onDangerSoft,
    required this.focusCanvas,
    required this.focusSurface,
  });

  // Backgrounds
  final Color canvas;
  final Color surface;
  final Color surfaceAlt;
  final Color border;
  final Color borderStrong;

  // Text
  final Color ink;
  final Color inkMuted;

  /// Hints / placeholders. Still ≥ 4.5:1 on [surface].
  final Color inkSubtle;

  // Brand
  final Color primary;
  final Color onPrimary;
  final Color primarySoft;
  final Color onPrimarySoft;

  // Accent — reward / streak ONLY (PRD §12.2)
  final Color accent;
  final Color onAccent;
  final Color accentSoft;

  /// Amber that is legible as *text/icon* on light surfaces (#F59E0B is not).
  final Color accentText;

  // Semantic
  final Color success;
  final Color successSoft;
  final Color danger;
  final Color onDanger;
  final Color dangerSoft;
  final Color onDangerSoft;

  // Immersive focus screen (dark in both themes)
  final Color focusCanvas;
  final Color focusSurface;
}

abstract final class AppColors {
  // ── Locked brand tokens (PRD §12.2) ────────────────────────────────────
  static const Color brandPrimary = Color(0xFF3730A3); // Deep Indigo
  static const Color brandAccent = Color(0xFFF59E0B); // Warm Amber
  static const Color brandDanger = Color(0xFFDC2626); // Muted Red

  // ── Raw palette (Tailwind scale, per PRD "Gray 50–900") ────────────────
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
    canvas: gray50,
    surface: Colors.white,
    surfaceAlt: gray100,
    border: gray200,
    borderStrong: gray400,
    ink: gray900, // 17:1 on white
    inkMuted: gray600, // 7.6:1 on white
    inkSubtle: gray500, // 4.8:1 on white
    primary: brandPrimary, // 9.9:1 on white
    onPrimary: Colors.white,
    primarySoft: indigo100,
    onPrimarySoft: brandPrimary,
    accent: brandAccent, // fills only — 2.2:1 on white
    onAccent: gray900,
    accentSoft: amber100,
    accentText: amber700, // 5.0:1 on white
    success: green700,
    successSoft: green100,
    danger: brandDanger, // 4.8:1 on white
    onDanger: Colors.white,
    dangerSoft: red100,
    onDangerSoft: red700,
    focusCanvas: indigo950,
    focusSurface: Color(0x14FFFFFF), // white @ 8%
  );

  // ── Dark ───────────────────────────────────────────────────────────────
  // #3730A3 is too dark to read on a dark canvas, so primary/danger shift
  // one step lighter here. Same hue family, AA contrast preserved.
  static const AppColorSet dark = AppColorSet(
    canvas: Color(0xFF0E0D1B),
    surface: Color(0xFF16152A),
    surfaceAlt: Color(0xFF1E1D36),
    border: Color(0xFF2A2945),
    borderStrong: Color(0xFF4B4A6B),
    ink: gray100,
    inkMuted: gray300,
    inkSubtle: gray400,
    primary: indigo300,
    onPrimary: indigo950,
    primarySoft: Color(0xFF29275E),
    onPrimarySoft: indigo200,
    accent: brandAccent,
    onAccent: gray900,
    accentSoft: Color(0xFF3A2A0A),
    accentText: amber400,
    success: green400,
    successSoft: Color(0xFF143D27),
    danger: red400,
    onDanger: Color(0xFF450A0A),
    dangerSoft: Color(0xFF4A1D1D),
    onDangerSoft: red300,
    focusCanvas: indigo950,
    focusSurface: Color(0x14FFFFFF),
  );

  static AppColorSet of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;
}
