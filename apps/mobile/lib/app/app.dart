import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeo/app/router/app_router.dart';
import 'package:homeo/core/theme/app_theme.dart';
import 'package:homeo/features/friction/data/detected_app_ingest.dart';
import 'package:homeo/features/settings/presentation/providers/preferences_controller.dart';
import 'package:homeo/l10n/l10n.dart';

class HomeoApp extends ConsumerStatefulWidget {
  const HomeoApp({super.key});

  @override
  ConsumerState<HomeoApp> createState() => _HomeoAppState();
}

class _HomeoAppState extends ConsumerState<HomeoApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Native (Android) may have logged "app opened" events while Flutter was
  /// asleep; pull them into the local DB whenever the app comes back.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(ref.read(detectedAppIngestProvider).ingestPending());
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    // Light / Dark / Auto from Settings → Appearance (design: ThemeContext).
    final themeMode = ref.watch(
      preferencesProvider.select((p) => p.flutterThemeMode),
    );

    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
