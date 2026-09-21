import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeo/core/theme/app_colors.dart';
import 'package:homeo/core/theme/app_dimens.dart';
import 'package:homeo/core/theme/app_theme.dart';
import 'package:homeo/core/utils/duration_format.dart';
import 'package:homeo/features/friction/domain/friction_level.dart';
import 'package:homeo/features/friction/domain/friction_rules.dart';
import 'package:homeo/features/friction/presentation/providers/friction_gate_controller.dart';
import 'package:homeo/features/friction/presentation/widgets/emergency_override_sheet.dart';
import 'package:homeo/l10n/l10n.dart';
import 'package:homeo/shared/widgets/choice_pill.dart';
import 'package:homeo/shared/widgets/remaining_builder.dart';

int _ceilSeconds(Duration d) => (d.inMilliseconds / 1000).ceil();

/// Whether the tab bar should be hidden behind this gate. Only the L0
/// banner leaves the app usable underneath.
bool gateCoversScreen(FrictionGateRequest? request) =>
    request != null && request.level != FrictionLevel.awareness;

/// The friction gate (PRD §11). Sits above the whole app so it works no
/// matter which tab is open; the app shell mounts it.
class FrictionGateOverlay extends ConsumerWidget {
  const FrictionGateOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final request = ref.watch(frictionGateControllerProvider);
    if (request == null) return const SizedBox.shrink();

    final controller = ref.read(frictionGateControllerProvider.notifier);

    return PopScope(
      canPop: false, // back = "back to focus", never a silent bypass
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) controller.returnToFocus();
      },
      child: switch (request.level) {
        FrictionLevel.awareness => _AwarenessBanner(request: request),
        FrictionLevel.fullBlock => _BlockScreen(request: request),
        _ => _GateCard(request: request),
      },
    );
  }
}

// ── L0 ─────────────────────────────────────────────────────────────────────

class _AwarenessBanner extends ConsumerStatefulWidget {
  const _AwarenessBanner({required this.request});

  final FrictionGateRequest request;

  @override
  ConsumerState<_AwarenessBanner> createState() => _AwarenessBannerState();
}

class _AwarenessBannerState extends ConsumerState<_AwarenessBanner> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(FrictionRules.awarenessBannerDuration, _dismiss);
  }

  void _dismiss() {
    ref.read(frictionGateControllerProvider.notifier).proceed();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    final request = widget.request;

    return Align(
      alignment: Alignment.topCenter,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Semantics(
            liveRegion: true,
            child: Material(
              color: colors.primarySoft,
              borderRadius: AppRadius.cardRadius,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: AppSpacing.lg,
                  top: AppSpacing.xs,
                  bottom: AppSpacing.xs,
                  end: AppSpacing.xs,
                ),
                child: Row(
                  children: [
                    ExcludeSemantics(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: colors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        l10n.gateAwarenessTitle(
                          request.appName,
                          request.attemptNumberToday,
                        ),
                        style: text.labelLarge?.copyWith(
                          color: colors.onPrimarySoft,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: l10n.setupClose,
                      onPressed: _dismiss,
                      icon: Icon(
                        Icons.close_rounded,
                        color: colors.onPrimarySoft,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── L3 ─────────────────────────────────────────────────────────────────────

class _BlockScreen extends ConsumerWidget {
  const _BlockScreen({required this.request});

  final FrictionGateRequest request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(frictionGateControllerProvider.notifier);

    // Always dark: calm and low-stimulus, like the active-session screen.
    return Theme(
      data: AppTheme.dark,
      child: Builder(
        builder: (context) {
          final l10n = context.l10n;
          final colors = AppColors.of(context);
          final text = Theme.of(context).textTheme;

          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: ColoredBox(
              color: colors.focusCanvas,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    color: colors.focusSurface,
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                  child: Icon(
                                    Icons.lock_outline_rounded,
                                    size: 36,
                                    color: colors.primary,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.xl),
                                Text(
                                  l10n.gateBlockTitle,
                                  style: text.titleLarge,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  l10n.gateBlockBody,
                                  style: text.bodyLarge?.copyWith(
                                    color: colors.inkMuted,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                ..._notes(context, request),
                              ],
                            ),
                          ),
                        ),
                      ),
                      FilledButton(
                        onPressed: controller.returnToFocus,
                        child: Text(l10n.commonBackToFocus),
                      ),
                      TextButton(
                        onPressed: () => showEmergencySheet(context),
                        style: TextButton.styleFrom(
                          foregroundColor: colors.inkMuted,
                        ),
                        child: Text(l10n.emergencyLink),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Small "why am I seeing this" lines — PRD §11.4: no black-box friction.
List<Widget> _notes(BuildContext context, FrictionGateRequest request) {
  final l10n = context.l10n;
  final colors = AppColors.of(context);
  final style = Theme.of(
    context,
  ).textTheme.bodySmall?.copyWith(color: colors.inkMuted);

  final lines = <String>[
    if (request.duringSession) l10n.gateSessionNote,
    if (request.escalatedByBurst) l10n.gateEscalatedNote,
  ];
  return [
    for (final line in lines) ...[
      const SizedBox(height: AppSpacing.md),
      Text(line, style: style, textAlign: TextAlign.center),
    ],
  ];
}

// ── L1 / L2 / L4 ───────────────────────────────────────────────────────────

class _GateCard extends ConsumerStatefulWidget {
  const _GateCard({required this.request});

  final FrictionGateRequest request;

  @override
  ConsumerState<_GateCard> createState() => _GateCardState();
}

class _GateCardState extends ConsumerState<_GateCard> {
  final _reason = TextEditingController();

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  bool get _hasReason =>
      _reason.text.trim().length >= FrictionRules.minReasonLength;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    final request = widget.request;
    final controller = ref.read(frictionGateControllerProvider.notifier);

    final (title, body) = switch (request.level) {
      FrictionLevel.micro => (
        l10n.gateMicroTitle,
        l10n.gateMicroBody(request.appName),
      ),
      FrictionLevel.reflective => (
        l10n.gateReflectiveTitle,
        l10n.gateReflectiveBody,
      ),
      _ => (l10n.gatePartnerTitle, l10n.gatePartnerBody),
    };

    return ColoredBox(
      color: Colors.black54,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Material(
              color: colors.surface,
              borderRadius: BorderRadius.circular(AppRadius.sheet),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(title, style: text.titleLarge),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      body,
                      style: text.bodyMedium?.copyWith(color: colors.inkMuted),
                    ),
                    ..._notes(context, request).map(
                      (w) => Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: w,
                      ),
                    ),
                    if (request.level == FrictionLevel.reflective ||
                        (request.level == FrictionLevel.partnerGated &&
                            request.partner == PartnerStage.none)) ...[
                      const SizedBox(height: AppSpacing.lg),
                      _ReasonField(controller: _reason),
                    ],
                    const SizedBox(height: AppSpacing.xl),
                    FilledButton(
                      onPressed: controller.returnToFocus,
                      child: Text(l10n.commonBackToFocus),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _proceedControl(context, controller),
                    TextButton(
                      onPressed: () => showEmergencySheet(context),
                      style: TextButton.styleFrom(
                        foregroundColor: colors.inkMuted,
                      ),
                      child: Text(l10n.emergencyLink),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// The one way through, specific to the level.
  Widget _proceedControl(
    BuildContext context,
    FrictionGateController controller,
  ) {
    final l10n = context.l10n;
    final request = widget.request;

    switch (request.level) {
      case FrictionLevel.micro:
        return RemainingBuilder(
          until: request.unlockAt!,
          builder: (context, remaining) => OutlinedButton(
            onPressed: remaining == Duration.zero
                ? () => controller.proceed()
                : null,
            child: Text(
              remaining == Duration.zero
                  ? l10n.gateConfirm
                  : l10n.gateConfirmWait(_ceilSeconds(remaining)),
            ),
          ),
        );

      case FrictionLevel.reflective:
        return RemainingBuilder(
          until: request.unlockAt!,
          builder: (context, remaining) => ListenableBuilder(
            listenable: _reason,
            builder: (context, _) => OutlinedButton(
              onPressed: remaining == Duration.zero && _hasReason
                  ? () => controller.proceed(reason: _reason.text)
                  : null,
              child: Text(
                remaining == Duration.zero
                    ? l10n.gateOpenApp(request.appName)
                    : l10n.gateOpenAppWait(
                        request.appName,
                        _ceilSeconds(remaining),
                      ),
              ),
            ),
          ),
        );

      case FrictionLevel.partnerGated:
        return switch (request.partner) {
          PartnerStage.none => ListenableBuilder(
            listenable: _reason,
            builder: (context, _) => OutlinedButton(
              onPressed: _hasReason
                  ? () => controller.requestPartnerOverride(_reason.text)
                  : null,
              child: Text(l10n.gatePartnerRequest),
            ),
          ),
          PartnerStage.pending => _PartnerPending(
            until: request.coolingOffEndsAt!,
          ),
          PartnerStage.denied => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Text(
              l10n.gatePartnerDenied,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        };

      case FrictionLevel.awareness:
      case FrictionLevel.fullBlock:
        return const SizedBox.shrink(); // rendered by their own widgets
    }
  }
}

class _PartnerPending extends StatelessWidget {
  const _PartnerPending({required this.until});

  final DateTime until;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = AppColors.of(context);
    final text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.gatePartnerPending, style: text.titleSmall),
        const SizedBox(height: AppSpacing.xs),
        RemainingBuilder(
          until: until,
          builder: (context, remaining) => Text(
            l10n.gatePartnerCoolingOff(
              formatClock(Duration(seconds: _ceilSeconds(remaining))),
            ),
            style: text.bodySmall?.copyWith(color: colors.inkMuted),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}

/// Free-text reason with quick picks (PRD §11.2 L2, §10.2 override reason).
class _ReasonField extends StatelessWidget {
  const _ReasonField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;

    final quickPicks = [
      l10n.gateReasonRest,
      l10n.gateReasonTask,
      l10n.exitReasonDistracted,
      l10n.exitReasonOther,
    ];

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.gateReasonLabel, style: text.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final pick in quickPicks)
                ChoicePill(
                  label: pick,
                  selected: controller.text == pick,
                  onSelected: () => controller.text = pick,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: controller,
            maxLines: 2,
            minLines: 1,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(hintText: l10n.gateReasonHint),
          ),
        ],
      ),
    );
  }
}
