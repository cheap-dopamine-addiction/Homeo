import 'package:flutter/material.dart';
import 'package:homeo/core/theme/app_colors.dart';
import 'package:homeo/core/theme/app_dimens.dart';

/// Pill-shaped single-choice chip (duration presets, exit reasons).
///
/// Colours are set explicitly so it looks identical in light/dark and never
/// depends on ChipTheme state resolution.
class ChoicePill extends StatelessWidget {
  const ChoicePill({
    required this.label,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      showCheckmark: false,
      labelStyle: textTheme.labelLarge?.copyWith(
        color: selected ? colors.onPrimary : colors.onPrimarySoft,
      ),
      backgroundColor: colors.primarySoft,
      selectedColor: colors.primary,
      side: BorderSide.none,
      shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
    );
  }
}
