import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeo/core/theme/app_colors.dart';
import 'package:homeo/core/theme/app_dimens.dart';
import 'package:homeo/core/utils/duration_format.dart';
import 'package:homeo/features/focus_session/domain/focus_rules.dart';
import 'package:homeo/features/focus_session/presentation/providers/focus_session_controller.dart';
import 'package:homeo/features/focus_session/presentation/widgets/duration_picker_sheet.dart';
import 'package:homeo/l10n/l10n.dart';
import 'package:homeo/shared/widgets/choice_pill.dart';

/// Focus tab, setup phase: pick a duration, optionally write an intention
/// (an implementation intention — PRD §3.2 / §9.1).
class SessionSetupView extends ConsumerStatefulWidget {
  const SessionSetupView({super.key});

  @override
  ConsumerState<SessionSetupView> createState() => _SessionSetupViewState();
}

class _SessionSetupViewState extends ConsumerState<SessionSetupView> {
  final _intention = TextEditingController();
  Duration _duration = FocusRules.defaultDuration;
  bool _isCustom = false;
  bool _starting = false;

  @override
  void dispose() {
    _intention.dispose();
    super.dispose();
  }

  Future<void> _pickCustom() async {
    final picked = await showDurationPickerSheet(
      context,
      initial: _isCustom ? _duration : FocusRules.defaultCustomDuration,
    );
    if (picked == null || !mounted) return;
    setState(() {
      _duration = picked;
      _isCustom = true;
    });
  }

  Future<void> _start() async {
    if (_starting) return;
    setState(() => _starting = true);
    await ref
        .read(focusSessionControllerProvider.notifier)
        .start(duration: _duration, intention: _intention.text);
    // On success this view is replaced; only reset if we are still here.
    if (mounted) setState(() => _starting = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    final controller = ref.read(focusSessionControllerProvider.notifier);

    return PopScope(
      canPop: false, // Android back closes setup instead of exiting the app
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) controller.closeSetup();
      },
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.sm,
                AppSpacing.sm,
                0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(l10n.setupTitle, style: text.headlineMedium),
                  ),
                  IconButton(
                    tooltip: l10n.setupClose,
                    onPressed: controller.closeSetup,
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.setupDurationLabel, style: text.titleSmall),
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        for (final minutes in FocusRules.presetMinutes)
                          ChoicePill(
                            label: l10n.durationPresetMinutes(minutes),
                            selected:
                                !_isCustom && _duration.inMinutes == minutes,
                            onSelected: () => setState(() {
                              _duration = Duration(minutes: minutes);
                              _isCustom = false;
                            }),
                          ),
                        ChoicePill(
                          label: _isCustom
                              ? formatFocusDuration(l10n, _duration)
                              : l10n.durationCustom,
                          selected: _isCustom,
                          onSelected: _pickCustom,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    Text(l10n.setupIntentionLabel, style: text.titleSmall),
                    const SizedBox(height: AppSpacing.md),
                    TextField(
                      controller: _intention,
                      minLines: 3,
                      maxLines: 5,
                      textInputAction: TextInputAction.newline,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(
                          FocusRules.maxIntentionLength,
                        ),
                      ],
                      decoration: InputDecoration(
                        hintText: l10n.setupIntentionHint,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.setupIntentionHelper,
                      style: text.bodySmall?.copyWith(color: colors.inkMuted),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.sm,
                AppSpacing.xl,
                AppSpacing.xl,
              ),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _starting ? null : _start,
                  child: Text(l10n.setupStartButton(formatClock(_duration))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
