import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homeo/core/theme/app_colors.dart';
import 'package:homeo/core/theme/app_dimens.dart';
import 'package:homeo/features/focus_session/domain/focus_rules.dart';
import 'package:homeo/l10n/l10n.dart';

/// Wheel picker (hours + minutes) for a custom session length.
/// Returns null when cancelled.
Future<Duration?> showDurationPickerSheet(
  BuildContext context, {
  required Duration initial,
}) {
  return showModalBottomSheet<Duration>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    builder: (_) => _DurationPickerSheet(initial: initial),
  );
}

class _DurationPickerSheet extends StatefulWidget {
  const _DurationPickerSheet({required this.initial});

  final Duration initial;

  @override
  State<_DurationPickerSheet> createState() => _DurationPickerSheetState();
}

class _DurationPickerSheetState extends State<_DurationPickerSheet> {
  late Duration _value = Duration(minutes: widget.initial.inMinutes);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    final valid = _value >= FocusRules.minDuration;
    final isLong = _value > FocusRules.longSessionHint;

    return SafeArea(
      top: false,
      child: Padding(
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
            Text(l10n.pickerTitle, style: text.titleLarge),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              height: 200,
              child: CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.hm,
                initialTimerDuration: _value,
                onTimerDurationChanged: (d) => setState(() => _value = d),
              ),
            ),
            // A hint, never a limit (prototype: > 2 hours).
            if (isLong) ...[
              const SizedBox(height: AppSpacing.md),
              Semantics(
                liveRegion: true,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: colors.accentSoft,
                    borderRadius: AppRadius.cardRadius,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 18,
                        color: colors.accentText,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          l10n.pickerLongSessionHint,
                          style: text.bodySmall?.copyWith(
                            color: colors.accentText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.pickerCancel),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: FilledButton(
                    onPressed: valid
                        ? () => Navigator.of(context).pop(_value)
                        : null,
                    child: Text(l10n.pickerConfirm),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
