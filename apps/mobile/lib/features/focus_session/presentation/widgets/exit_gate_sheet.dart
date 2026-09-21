import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeo/core/theme/app_colors.dart';
import 'package:homeo/core/theme/app_dimens.dart';
import 'package:homeo/features/focus_session/domain/focus_rules.dart';
import 'package:homeo/features/focus_session/domain/focus_session_state.dart';
import 'package:homeo/features/focus_session/domain/session_reflection.dart';
import 'package:homeo/features/focus_session/presentation/providers/focus_session_controller.dart';
import 'package:homeo/l10n/l10n.dart';
import 'package:homeo/shared/widgets/choice_pill.dart';

class ExitGateResult {
  const ExitGateResult({required this.leave, this.reason});

  final bool leave;
  final ExitReason? reason;
}

/// Friction gate for leaving a session early (PRD §9.1 / §11).
///
/// Always has a clear way out: dismissing the sheet, or "back to focus",
/// keeps the session going. Returns null when dismissed.
Future<ExitGateResult?> showExitGateSheet(BuildContext context) {
  return showModalBottomSheet<ExitGateResult>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    builder: (_) => const _ExitGateSheet(),
  );
}

class _ExitGateSheet extends ConsumerStatefulWidget {
  const _ExitGateSheet();

  @override
  ConsumerState<_ExitGateSheet> createState() => _ExitGateSheetState();
}

class _ExitGateSheetState extends ConsumerState<_ExitGateSheet> {
  Timer? _timer;
  int _remaining = FocusRules.exitGateCountdownSeconds;
  ExitReason? _reason;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _remaining--);
      if (_remaining <= 0) timer.cancel();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _reasonLabel(ExitReason reason) {
    final l10n = context.l10n;
    return switch (reason) {
      ExitReason.emergency => l10n.exitReasonEmergency,
      ExitReason.tired => l10n.exitReasonTired,
      ExitReason.distracted => l10n.exitReasonDistracted,
      ExitReason.other => l10n.exitReasonOther,
    };
  }

  @override
  Widget build(BuildContext context) {
    // If the timer finishes the session while this sheet is open, close it.
    ref.listen(focusSessionControllerProvider.select((s) => s.phase), (
      previous,
      next,
    ) {
      if (next != FocusPhase.running) Navigator.of(context).pop();
    });

    final l10n = context.l10n;
    final colors = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    final canLeave = _remaining <= 0;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.sm,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.exitGateTitle, style: text.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.exitGateSubtitle,
              style: text.bodyMedium?.copyWith(color: colors.inkMuted),
            ),
            const SizedBox(height: AppSpacing.xl),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final reason in ExitReason.values)
                  ChoicePill(
                    label: _reasonLabel(reason),
                    selected: _reason == reason,
                    onSelected: () => setState(
                      () => _reason = _reason == reason ? null : reason,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.commonBackToFocus),
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(
              onPressed: canLeave
                  ? () => Navigator.of(
                      context,
                    ).pop(ExitGateResult(leave: true, reason: _reason))
                  : null,
              child: Text(
                canLeave
                    ? l10n.exitGateLeave
                    : l10n.exitGateLeaveWait(_remaining),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
