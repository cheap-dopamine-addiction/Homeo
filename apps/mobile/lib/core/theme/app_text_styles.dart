import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';

/// Type scale — PRD §12.2: Inter (SemiBold headings / Regular body).
///
/// Inter has no Thai glyphs, so Noto Sans Thai is the fallback. Line heights
/// stay ≥ 1.3 everywhere so Thai tone marks are never clipped.
abstract final class AppTextStyles {
  static const String fontFamily = 'Inter';
  static const List<String> fontFamilyFallback = ['NotoSansThai'];

  static const TextStyle _base = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFamilyFallback,
    letterSpacing: 0,
    height: 1.45,
  );

  /// Countdown digits. Tabular figures stop the timer from jittering.
  static final TextStyle timer = _base.copyWith(
    fontSize: 56,
    fontWeight: FontWeight.w600,
    height: 1.15,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  static final TextStyle headline = _base.copyWith(
    fontSize: 26,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  static final TextStyle titleLarge = _base.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  static final TextStyle titleMedium = _base.copyWith(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.35,
  );
  static final TextStyle titleSmall = _base.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static final TextStyle bodyLarge = _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  static final TextStyle bodyMedium = _base.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );
  static final TextStyle bodySmall = _base.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle labelLarge = _base.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  static final TextStyle labelMedium = _base.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  static final TextStyle labelSmall = _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  /// Maps the scale onto Material's slots.
  ///
  ///   displayLarge   → timer
  ///   headlineMedium → screen title
  static TextTheme textTheme({required Color ink}) {
    return TextTheme(
      displayLarge: timer,
      headlineMedium: headline,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      titleSmall: titleSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
      labelMedium: labelMedium,
      labelSmall: labelSmall,
    ).apply(displayColor: ink, bodyColor: ink);
  }
}
