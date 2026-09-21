import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeo/core/theme/app_colors.dart';
import 'package:homeo/core/theme/app_dimens.dart';
import 'package:homeo/core/utils/duration_format.dart';
import 'package:homeo/features/focus_session/domain/focus_session_state.dart';
import 'package:homeo/features/focus_session/domain/session_reflection.dart';
import 'package:homeo/features/focus_session/presentation/providers/focus_session_controller.dart';
import 'package:homeo/l10n/l10n.dart';

/// Focus tab, summary phase: how it went + optional one-tap mood.
/// Same supportive tone whether the session completed or ended early.
class SessionSummaryView extends ConsumerStatefulWidget {
  const SessionSummaryView({super.key});

  @override
  ConsumerState<SessionSummaryView> createState() => _SessionSummaryViewState();
}

class _SessionSummaryViewState extends ConsumerState<SessionSummaryView> {
  SessionMood? _mood;

  Future<void> _finish(SessionMood? mood) {
    return ref
        .read(focusSessionControllerProvider.notifier)
        .completeSummary(mood: mood);
  }

  @override
  Widget build(BuildContext context) {
    final summary = ref.watch(focusSessionControllerProvider);
    if (summary is! FocusSummary) return const SizedBox.shrink();

    final l10n = context.l10n;
    final colors = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    final completed = summary.completed;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _finish(null);
      },
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.xl),
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: completed
                            ? colors.successSoft
                            : colors.primarySoft,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        completed
                            ? Icons.check_rounded
                            : Icons.favorite_border_rounded,
                        size: 36,
                        color: completed
                            ? colors.success
                            : colors.onPrimarySoft,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      completed
                          ? l10n.summaryCompletedTitle
                          : l10n.summaryAbortedTitle,
                      style: text.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.summaryFocused(
                        formatFocusDuration(
                          l10n,
                          summary.session.actualDuration,
                        ),
                      ),
                      style: text.bodyLarge?.copyWith(color: colors.inkMuted),
                      textAlign: TextAlign.center,
                    ),
                    if (!completed) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        l10n.summaryAbortedNote,
                        style: text.bodySmall?.copyWith(color: colors.inkMuted),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    if (summary.session.intention.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: AppRadius.cardRadius,
                          border: Border.all(color: colors.border),
                        ),
                        child: Text(
                          summary.session.intention,
                          style: text.bodyMedium,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xxl),
                    Text(l10n.summaryMoodQuestion, style: text.titleSmall),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        for (final mood in SessionMood.values) ...[
                          Expanded(
                            child: _MoodOption(
                              mood: mood,
                              selected: _mood == mood,
                              onTap: () => setState(
                                () => _mood = _mood == mood ? null : mood,
                              ),
                            ),
                          ),
                          if (mood != SessionMood.values.last)
                            const SizedBox(width: AppSpacing.sm),
                        ],
                      ],
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
                AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton(
                    onPressed: () => _finish(_mood),
                    child: Text(l10n.summarySave),
                  ),
                  TextButton(
                    onPressed: () => _finish(null),
                    style: TextButton.styleFrom(
                      foregroundColor: colors.inkMuted,
                    ),
                    child: Text(l10n.summarySkip),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoodOption extends StatelessWidget {
  const _MoodOption({
    required this.mood,
    required this.selected,
    required this.onTap,
  });

  final SessionMood mood;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = AppColors.of(context);
    final text = Theme.of(context).textTheme;

    final (icon, label) = switch (mood) {
      SessionMood.hard => (
        Icons.sentiment_very_dissatisfied_outlined,
        l10n.moodHard,
      ),
      SessionMood.okay => (Icons.sentiment_neutral_outlined, l10n.moodOkay),
      SessionMood.good => (Icons.sentiment_satisfied_outlined, l10n.moodGood),
      SessionMood.great => (
        Icons.sentiment_very_satisfied_outlined,
        l10n.moodGreat,
      ),
    };

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      onTap: onTap,
      child: ExcludeSemantics(
        child: Material(
          color: selected ? colors.primary : colors.surface,
          borderRadius: AppRadius.cardRadius,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadius.cardRadius,
            child: Container(
              constraints: const BoxConstraints(minHeight: 72),
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.md,
                horizontal: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                borderRadius: AppRadius.cardRadius,
                border: Border.all(
                  color: selected ? colors.primary : colors.border,
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 26,
                    color: selected ? colors.onPrimary : colors.inkMuted,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: text.labelSmall?.copyWith(
                      color: selected ? colors.onPrimary : colors.inkMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
