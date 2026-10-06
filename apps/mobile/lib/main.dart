import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeo/app/boot.dart';
import 'package:intl/date_symbol_data_local.dart';

/// Entry point.
///
/// Launch-failure hardening (blank / stuck screen):
///  * every uncaught error is logged instead of vanishing,
///  * in release mode a widget build error is rendered as readable text
///    instead of Flutter's blank grey box,
///  * all async start-up work lives in `bootProvider` ([BootApp]); if the
///    local DB cannot open, the user sees the reason and a Retry button
///    instead of an endless spinner.
Future<void> main() async {
  await runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    _installErrorHandlers();

    // DateFormat needs locale data; never let this block the first frame.
    try {
      await initializeDateFormatting();
    } catch (e, st) {
      debugPrint('initializeDateFormatting failed: $e\n$st');
    }

    runApp(const ProviderScope(child: BootApp()));
  }, (error, stack) => debugPrint('Uncaught zone error: $error\n$stack'));
}

void _installErrorHandlers() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('FlutterError: ${details.exceptionAsString()}');
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('PlatformDispatcher error: $error\n$stack');
    return true;
  };

  // Release builds replace failed widgets with an empty grey box, which looks
  // exactly like "the app shows nothing". Show the message instead.
  ErrorWidget.builder = (details) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ColoredBox(
        color: const Color(0xFFFFFFFF),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            details.exceptionAsString(),
            style: const TextStyle(
              color: Color(0xFFB91C1C),
              fontSize: 12,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  };
}
