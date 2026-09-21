// Applies the Android/iOS edits Homeo needs (see docs/NATIVE_SETUP.md).
//
//   cd apps/mobile
//   dart tool/apply_native_config.dart
//
// Safe to run more than once: every edit is skipped if it is already there.
// Each file is backed up once as `<file>.homeo.bak`; if an edit would leave a
// file unbalanced it is restored automatically and reported as "manual".
import 'dart:io';

final List<String> _report = <String>[];
bool _needsManual = false;

void main() {
  if (!File('pubspec.yaml').existsSync() ||
      !Directory('android').existsSync()) {
    stderr.writeln(
      'Run this from apps/mobile (the folder that contains pubspec.yaml and android/).',
    );
    exit(1);
  }

  _patchManifest('android/app/src/main/AndroidManifest.xml');

  if (File('android/app/build.gradle.kts').existsSync()) {
    _patchGradle('android/app/build.gradle.kts', kotlin: true);
  } else if (File('android/app/build.gradle').existsSync()) {
    _patchGradle('android/app/build.gradle', kotlin: false);
  } else {
    _manual('android/app/build.gradle(.kts) not found');
  }

  if (Directory('ios').existsSync()) {
    _patchAppDelegate('ios/Runner/AppDelegate.swift');
  } else {
    _report.add('- iOS: no ios/ folder, skipped');
  }

  stdout.writeln('\nHomeo native configuration');
  stdout.writeln('==========================');
  for (final line in _report) {
    stdout.writeln(line);
  }
  if (_needsManual) {
    stdout.writeln(
      '\nSome edits need to be done by hand: see docs/NATIVE_SETUP.md.',
    );
  } else {
    stdout.writeln('\nDone.');
  }
}

// ── helpers ────────────────────────────────────────────────────────────────

void _manual(String message) {
  _needsManual = true;
  _report.add('! MANUAL: $message');
}

String? _read(String path) {
  final file = File(path);
  return file.existsSync() ? file.readAsStringSync() : null;
}

void _write(String path, String original, String updated) {
  final backup = File('$path.homeo.bak');
  if (!backup.existsSync()) backup.writeAsStringSync(original);
  File(path).writeAsStringSync(updated);
}

String _newline(String s) => s.contains('\r\n') ? '\r\n' : '\n';

/// (#open − #close). Compared before/after an edit instead of demanding
/// perfect balance, because comments in the original may be unbalanced.
int _delta(String s, String open, String close) {
  var depth = 0;
  for (final unit in s.runes) {
    final ch = String.fromCharCode(unit);
    if (ch == open) depth++;
    if (ch == close) depth--;
  }
  return depth;
}

bool _sameBrackets(String before, String after, List<String> pairs) {
  for (final pair in pairs) {
    if (_delta(before, pair[0], pair[1]) != _delta(after, pair[0], pair[1])) {
      return false;
    }
  }
  return true;
}

/// Index of the first character of the line containing [index].
int _lineStart(String s, int index) => s.lastIndexOf('\n', index) + 1;

// ── AndroidManifest.xml ────────────────────────────────────────────────────

void _patchManifest(String path) {
  final original = _read(path);
  if (original == null) {
    _manual('$path not found');
    return;
  }
  var s = original;
  final nl = _newline(s);
  final done = <String>[];

  final missingPermissions = <String>[
    'android.permission.POST_NOTIFICATIONS',
    'android.permission.SCHEDULE_EXACT_ALARM',
  ].where((p) => !s.contains(p)).toList();

  final appIndex = s.indexOf('<application');
  if (appIndex < 0) {
    _manual('$path has no <application> element');
    return;
  }

  if (missingPermissions.isNotEmpty) {
    final lines = missingPermissions
        .map((p) => '    <uses-permission android:name="$p"/>$nl')
        .join();
    final at = _lineStart(s, appIndex);
    s = s.substring(0, at) + lines + s.substring(at);
    done.add('permissions');
  }

  // Auto-Backup could restore the DB without the Keystore key.
  final tag = RegExp(r'<application\b[^>]*>').firstMatch(s);
  if (tag != null) {
    final text = tag.group(0)!;
    String? replaced;
    if (RegExp(r'android:allowBackup\s*=\s*"false"').hasMatch(text)) {
      replaced = null;
    } else if (text.contains('android:allowBackup')) {
      replaced = text.replaceFirst(
        RegExp(r'android:allowBackup\s*=\s*"[^"]*"'),
        'android:allowBackup="false"',
      );
    } else {
      replaced = text.replaceFirst(
        '<application',
        '<application$nl        android:allowBackup="false"',
      );
    }
    if (replaced != null) {
      s = s.substring(0, tag.start) + replaced + s.substring(tag.end);
      done.add('allowBackup=false');
    }
  }

  if (!s.contains('ScheduledNotificationReceiver')) {
    final close = s.lastIndexOf('</application>');
    if (close < 0) {
      _manual('$path: could not find </application> to add the receiver');
      return;
    }
    final at = _lineStart(s, close);
    s =
        s.substring(0, at) +
        '        <receiver$nl'
            '            android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver"$nl'
            '            android:exported="false" />$nl' +
        s.substring(at);
    done.add('notification receiver');
  }

  if (done.isEmpty) {
    _report.add('- AndroidManifest.xml: already configured');
    return;
  }
  if ('<application'.allMatches(s).length != 1 ||
      '</application>'.allMatches(s).length != 1) {
    _manual('$path: automatic edit looked wrong and was NOT applied');
    return;
  }
  _write(path, original, s);
  _report.add('- AndroidManifest.xml: added ${done.join(', ')}');
}

// ── android/app/build.gradle(.kts) ─────────────────────────────────────────

void _patchGradle(String path, {required bool kotlin}) {
  final original = _read(path);
  if (original == null) {
    _manual('$path not found');
    return;
  }
  var s = original;
  final nl = _newline(s);
  final done = <String>[];

  // 1) core library desugaring switch
  final flag = kotlin
      ? 'isCoreLibraryDesugaringEnabled = true'
      : 'coreLibraryDesugaringEnabled true';
  if (!s.contains('CoreLibraryDesugaringEnabled') &&
      !s.contains('coreLibraryDesugaringEnabled')) {
    final compileOptions = RegExp(r'compileOptions\s*\{').firstMatch(s);
    if (compileOptions != null) {
      s =
          s.substring(0, compileOptions.end) +
          '$nl        $flag' +
          s.substring(compileOptions.end);
      done.add('desugaring flag');
    } else {
      final androidBlock = RegExp(r'\bandroid\s*\{').firstMatch(s);
      if (androidBlock == null) {
        _manual('$path: no android { } block found');
        return;
      }
      s =
          s.substring(0, androidBlock.end) +
          '$nl    compileOptions {$nl        $flag$nl    }' +
          s.substring(androidBlock.end);
      done.add('desugaring flag (new compileOptions)');
    }
  }

  // 2) minSdk >= 23 (flutter_secure_storage)
  final minSdkNew = kotlin
      ? 'maxOf(flutter.minSdkVersion, 23)'
      : 'Math.max(flutter.minSdkVersion, 23)';
  final minSdkLine = RegExp(
    r'(minSdk(?:Version)?\s*(?:=\s*|\(\s*|\s+))([^\r\n)]+)(\)?)',
  );
  final minMatch = minSdkLine.firstMatch(s);
  if (minMatch != null) {
    final value = minMatch.group(2)!.trim();
    String? newValue;
    if (value == 'flutter.minSdkVersion') {
      newValue = minSdkNew;
    } else {
      final literal = int.tryParse(value);
      if (literal != null && literal < 23) newValue = '23';
    }
    if (newValue != null) {
      s =
          s.substring(0, minMatch.start) +
          '${minMatch.group(1)}$newValue${minMatch.group(3)}' +
          s.substring(minMatch.end);
      done.add('minSdk >= 23');
    }
  }

  // 3) desugar library dependency
  if (!s.contains('coreLibraryDesugaring(') &&
      !s.contains("coreLibraryDesugaring '") &&
      !s.contains('coreLibraryDesugaring "')) {
    final dep = kotlin
        ? 'coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")'
        : "coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.1.5'";
    final block = RegExp(r'^dependencies\s*\{', multiLine: true).firstMatch(s);
    if (block != null) {
      s = s.substring(0, block.end) + '$nl    $dep' + s.substring(block.end);
    } else {
      s = '${s.trimRight()}$nl${nl}dependencies {$nl    $dep$nl}$nl';
    }
    done.add('desugar_jdk_libs dependency');
  }

  final name = path.split('/').last;
  if (done.isEmpty) {
    _report.add('- $name: already configured');
    return;
  }
  if (!_sameBrackets(original, s, ['{}', '()'])) {
    _manual('$path: automatic edit looked wrong and was NOT applied');
    return;
  }
  _write(path, original, s);
  _report.add('- $name: added ${done.join(', ')}');
}

// ── ios/Runner/AppDelegate.swift ───────────────────────────────────────────

void _patchAppDelegate(String path) {
  final original = _read(path);
  if (original == null) {
    _manual('$path not found');
    return;
  }
  if (original.contains('UNUserNotificationCenter.current().delegate')) {
    _report.add('- AppDelegate.swift: already configured');
    return;
  }
  var s = original;
  final nl = _newline(s);

  final launch = RegExp(
    r'didFinishLaunchingWithOptions[^{]*\{',
    dotAll: true,
  ).firstMatch(s);
  if (launch == null) {
    _manual(
      '$path: could not find application(_:didFinishLaunchingWithOptions:); '
      'add  UNUserNotificationCenter.current().delegate = '
      'self as? UNUserNotificationCenterDelegate  at its start',
    );
    return;
  }

  final insert =
      '$nl'
      '    if #available(iOS 10.0, *) {$nl'
      '      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate$nl'
      '    }';
  s = s.substring(0, launch.end) + insert + s.substring(launch.end);

  if (!s.contains('import UserNotifications')) {
    final imports = RegExp(r'^import [^\r\n]+', multiLine: true).allMatches(s);
    if (imports.isNotEmpty) {
      final last = imports.last;
      s =
          s.substring(0, last.end) +
          '${nl}import UserNotifications' +
          s.substring(last.end);
    }
  }

  if (!_sameBrackets(original, s, ['{}', '()'])) {
    _manual('$path: automatic edit looked wrong and was NOT applied');
    return;
  }
  _write(path, original, s);
  _report.add('- AppDelegate.swift: added notification delegate');
}
