import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeo/app/app.dart';
import 'package:homeo/core/local_db/database_provider.dart';
import 'package:homeo/core/notifications/notification_service.dart';
import 'package:homeo/core/theme/app_theme.dart';
import 'package:homeo/features/friction/data/deep_link_service.dart';
import 'package:homeo/features/friction/data/detected_app_ingest.dart';

/// One-time start-up work.
///
/// Only the local database is *fatal*: nothing works without it. Everything
/// else (notifications, deep links, importing native events) is best effort
/// and must never keep the user on a blank screen.
///
/// `retry` is disabled on purpose: Riverpod 3 retries a failing provider with
/// exponential back-off, which would keep the UI on the loading spinner for
/// minutes instead of showing the error.
final bootProvider = FutureProvider<void>((ref) async {
  final db = ref.read(appDatabaseProvider);
  await db.customSelect('SELECT 1').get().timeout(const Duration(seconds: 10));

  await _soft('notifications', () async {
    final notifications = ref.read(notificationServiceProvider);
    await notifications.init();
    await notifications.scheduleWeeklySummary();
  });

  await _soft('deep links', () => ref.read(deepLinkServiceProvider).start());

  await _soft(
    'native events',
    () => ref.read(detectedAppIngestProvider).ingestPending(),
  );
}, retry: (retryCount, error) => null);

Future<void> _soft(String label, Future<void> Function() task) async {
  try {
    await task().timeout(const Duration(seconds: 8));
  } catch (e, st) {
    debugPrint('Boot step "$label" failed (ignored): $e\n$st');
  }
}

/// Shows a spinner while booting, a readable error if booting failed, and the
/// real app once ready.
class BootApp extends ConsumerWidget {
  const BootApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boot = ref.watch(bootProvider);
    return boot.when(
      data: (_) => const HomeoApp(),
      loading: () => const _BootShell(child: CircularProgressIndicator()),
      error: (error, stack) => _BootShell(
        child: _BootError(
          error: error,
          stack: stack,
          onRetry: () => ref.invalidate(bootProvider),
        ),
      ),
    );
  }
}

class _BootShell extends StatelessWidget {
  const _BootShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: Scaffold(
        body: SafeArea(child: Center(child: child)),
      ),
    );
  }
}

class _BootError extends StatelessWidget {
  const _BootError({
    required this.error,
    required this.stack,
    required this.onRetry,
  });

  final Object error;
  final StackTrace stack;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final trace = stack.toString().split('\n').take(6).join('\n');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Homeo could not start', style: text.titleLarge),
          const SizedBox(height: 12),
          SelectableText('$error', style: text.bodyMedium),
          const SizedBox(height: 12),
          SelectableText(trace, style: text.bodySmall),
          const SizedBox(height: 24),
          FilledButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
