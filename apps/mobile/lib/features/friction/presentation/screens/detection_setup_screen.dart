import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:homeo/app/router/app_routes.dart';
import 'package:homeo/core/notifications/notification_service.dart';
import 'package:homeo/core/theme/app_colors.dart';
import 'package:homeo/core/theme/app_dimens.dart';
import 'package:homeo/features/friction/data/blocker_bridge.dart';
import 'package:homeo/features/friction/domain/app_catalog.dart';
import 'package:homeo/l10n/l10n.dart';

/// Setup for "app opened" warnings (warning only — nothing is ever blocked).
///
/// Android: Accessibility service + notifications + battery optimisation.
/// iOS: Shortcuts automation that opens `homeo://distraction-event?app=<id>`.
/// The limits are stated plainly in the UI, not hidden.
class DetectionSetupScreen extends ConsumerStatefulWidget {
  const DetectionSetupScreen({super.key});

  @override
  ConsumerState<DetectionSetupScreen> createState() =>
      _DetectionSetupScreenState();
}

class _DetectionSetupScreenState extends ConsumerState<DetectionSetupScreen>
    with WidgetsBindingObserver {
  bool _accessibility = false;
  bool _notifications = false;
  bool _battery = false;

  bool get _isAndroid => defaultTargetPlatform == TargetPlatform.android;
  bool get _isIos => defaultTargetPlatform == TargetPlatform.iOS;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_refresh());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// The user comes back from a system settings page → re-read the state.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(_refresh());
  }

  Future<void> _refresh() async {
    final bridge = ref.read(blockerBridgeProvider);
    final accessibility = _isAndroid
        ? await bridge.isAccessibilityEnabled()
        : false;
    final battery = _isAndroid
        ? await bridge.isIgnoringBatteryOptimizations()
        : false;
    final notifications = await ref
        .read(notificationServiceProvider)
        .hasPermission();
    if (!mounted) return;
    setState(() {
      _accessibility = accessibility;
      _battery = battery;
      _notifications = notifications;
    });
  }

  Future<void> _requestNotifications() async {
    await ref.read(notificationServiceProvider).requestPermission();
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    final bridge = ref.read(blockerBridgeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.detectTitle),
        backgroundColor: colors.canvas,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          Text(
            l10n.detectIntro,
            style: text.bodyMedium?.copyWith(color: colors.inkMuted),
          ),
          const SizedBox(height: AppSpacing.xl),
          OutlinedButton(
            onPressed: () => context.push(AppRoutes.frictionSettings),
            child: Text(l10n.detectManageApps),
          ),
          const SizedBox(height: AppSpacing.xl),
          if (_isAndroid) ...[
            Text(l10n.detectAndroidSection, style: text.titleSmall),
            const SizedBox(height: AppSpacing.md),
            _StepCard(
              title: l10n.detectAccessTitle,
              body: l10n.detectAccessBody,
              done: _accessibility,
              actionLabel: l10n.detectOpenSettings,
              onAction: () => bridge.openAccessibilitySettings(),
            ),
            const SizedBox(height: AppSpacing.md),
            _StepCard(
              title: l10n.detectNotifTitle,
              body: l10n.detectNotifBody,
              done: _notifications,
              actionLabel: l10n.detectAllow,
              onAction: _requestNotifications,
            ),
            const SizedBox(height: AppSpacing.md),
            _StepCard(
              title: l10n.detectBatteryTitle,
              body: l10n.detectBatteryBody,
              done: _battery,
              actionLabel: l10n.detectAllow,
              onAction: () => bridge.requestIgnoreBatteryOptimizations(),
            ),
            const SizedBox(height: AppSpacing.md),
            _InfoCard(title: l10n.detectOemTitle, body: l10n.detectOemBody),
          ],
          if (_isIos) ...[
            Text(l10n.detectIosSection, style: text.titleSmall),
            const SizedBox(height: AppSpacing.md),
            _StepCard(
              title: l10n.detectNotifTitle,
              body: l10n.detectNotifBody,
              done: _notifications,
              actionLabel: l10n.detectAllow,
              onAction: _requestNotifications,
            ),
            const SizedBox(height: AppSpacing.md),
            for (final step in [
              l10n.detectIosStep1,
              l10n.detectIosStep2,
              l10n.detectIosStep3,
              l10n.detectIosStep4,
            ])
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Text(step, style: text.bodyMedium),
              ),
            const SizedBox(height: AppSpacing.md),
            for (final app in AppCatalog.apps)
              _LinkRow(app: app, copyLabel: l10n.detectIosCopyLink),
            const SizedBox(height: AppSpacing.lg),
            _InfoCard(
              title: l10n.detectIosLimitsTitle,
              body:
                  '• ${l10n.detectIosLimit1}\n'
                  '• ${l10n.detectIosLimit2}\n'
                  '• ${l10n.detectIosLimit3}',
            ),
          ],
          if (!_isAndroid && !_isIos)
            Text(
              l10n.comingSoon,
              style: text.bodyMedium?.copyWith(color: colors.inkMuted),
            ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            l10n.detectNoBlockNote,
            style: text.bodySmall?.copyWith(color: colors.inkMuted),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.title,
    required this.body,
    required this.done,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String body;
  final bool done;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = AppColors.of(context);
    final text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: done ? colors.success : colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                done
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: done ? colors.success : colors.inkMuted,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Text(title, style: text.titleSmall)),
              Text(
                done ? l10n.detectStatusOn : l10n.detectStatusOff,
                style: text.labelMedium?.copyWith(
                  color: done ? colors.success : colors.inkMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(body, style: text.bodySmall?.copyWith(color: colors.inkMuted)),
          if (!done) ...[
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: AppRadius.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: text.titleSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(body, style: text.bodySmall?.copyWith(color: colors.inkMuted)),
        ],
      ),
    );
  }
}

/// One Shortcuts link per watched app (iOS has no bulk setup).
class _LinkRow extends StatelessWidget {
  const _LinkRow({required this.app, required this.copyLabel});

  final CatalogApp app;
  final String copyLabel;

  String get _link => 'homeo://distraction-event?app=${app.packageId}';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = AppColors.of(context);
    final text = Theme.of(context).textTheme;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(app.icon),
      title: Text(app.displayName),
      subtitle: Text(
        _link,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: text.bodySmall?.copyWith(color: colors.inkMuted),
      ),
      trailing: IconButton(
        tooltip: copyLabel,
        icon: const Icon(Icons.copy_rounded),
        onPressed: () async {
          final messenger = ScaffoldMessenger.of(context);
          await Clipboard.setData(ClipboardData(text: _link));
          messenger.showSnackBar(SnackBar(content: Text(l10n.detectIosCopied)));
        },
      ),
    );
  }
}
