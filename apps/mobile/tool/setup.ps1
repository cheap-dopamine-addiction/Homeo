# Run from apps/mobile in PowerShell:  .\tool\setup.ps1
# If PowerShell blocks the script:  powershell -ExecutionPolicy Bypass -File .\tool\setup.ps1
# Stops at the first failing step so you see the first real error.
$ErrorActionPreference = 'Stop'

function Step($msg) { Write-Host "`n>> $msg" -ForegroundColor Cyan }
function Run($cmd) { Invoke-Expression $cmd; if ($LASTEXITCODE -ne 0) { throw "Failed: $cmd" } }

Step '0/7  Flutter version (need a recent stable: Flutter >= 3.35 / Dart >= 3.9)'
Run 'flutter --version'

Step '1/7  Remove the default counter test'
Remove-Item -Force -ErrorAction SilentlyContinue test/widget_test.dart

Step '2/7  Android/iOS configuration (manifest, gradle, AppDelegate) - backups: *.homeo.bak'
Run 'dart tool/apply_native_config.dart'

Step '3/7  flutter pub get (also runs gen-l10n)'
Run 'flutter pub get'

Step '4/7  flutter gen-l10n'
Run 'flutter gen-l10n'
if (-not (Test-Path lib/l10n/gen/app_localizations.dart)) { throw 'gen-l10n did not write lib/l10n/gen/ - see docs/SETUP_GUIDE.md section F' }

Step '5/7  build_runner (creates the 17 *.g.dart files)'
Run 'dart run build_runner build --delete-conflicting-outputs'

Step '6/7  dart format + flutter analyze'
Run 'dart format lib test tool'
Run 'flutter analyze --no-fatal-infos'

Step '7/7  flutter test'
Run 'flutter test'

Write-Host "`nAll checks passed. Now: flutter run" -ForegroundColor Green
