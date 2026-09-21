#!/usr/bin/env bash
# Run from apps/mobile:  bash tool/setup.sh
# Stops at the first failing step so you see the *first* real error.
set -euo pipefail

step() { printf '\n\033[1;36m▶ %s\033[0m\n' "$1"; }

step "0/7  Flutter version (need a recent stable: Flutter >= 3.35 / Dart >= 3.9)"
flutter --version

step "1/7  Remove the default counter test (it references MyApp and would fail)"
rm -f test/widget_test.dart

step "2/7  Android/iOS configuration (manifest, gradle, AppDelegate) — backups: *.homeo.bak"
dart tool/apply_native_config.dart

step "3/7  flutter pub get  (also runs gen-l10n because pubspec has generate: true)"
flutter pub get

step "4/7  flutter gen-l10n  (creates lib/l10n/gen/app_localizations*.dart)"
flutter gen-l10n
test -f lib/l10n/gen/app_localizations.dart || { echo "gen-l10n did not write lib/l10n/gen/ — see docs/SETUP_GUIDE.md §F"; exit 1; }

step "5/7  build_runner  (creates the 17 *.g.dart files)"
dart run build_runner build --delete-conflicting-outputs

step "6/7  dart format + flutter analyze"
dart format lib test tool
flutter analyze --no-fatal-infos

step "7/7  flutter test"
flutter test

printf '\n\033[1;32m✔ All checks passed. Now: flutter run\033[0m\n'
