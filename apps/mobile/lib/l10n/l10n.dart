import 'package:flutter/widgets.dart';
import 'package:homeo/l10n/gen/app_localizations.dart';

export 'package:homeo/l10n/gen/app_localizations.dart';

extension AppL10nX on BuildContext {
  /// `context.l10n.focusStartCta`
  AppLocalizations get l10n => AppLocalizations.of(this);
}
