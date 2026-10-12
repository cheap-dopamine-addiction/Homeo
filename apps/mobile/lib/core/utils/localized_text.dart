import 'package:flutter/widgets.dart';

/// Inline Thai / English text for screens ported from the Homeo (P-type)
/// design, which ships Thai copy only. Falls back to English for every
/// non-Thai locale, matching `lookupAppLocalizations`.
extension LocalizedTextX on BuildContext {
  bool get isThai => Localizations.localeOf(this).languageCode == 'th';

  String tx(String th, String en) => isThai ? th : en;
}
