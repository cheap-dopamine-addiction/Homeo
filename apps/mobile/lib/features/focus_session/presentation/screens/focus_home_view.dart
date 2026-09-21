import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeo/core/theme/app_colors.dart';
import 'package:homeo/core/theme/app_dimens.dart';
import 'package:homeo/core/time/clock.dart';
import 'package:homeo/core/utils/duration_format.dart';
import 'package:homeo/features/focus_session/domain/focus_session.dart';
import 'package:homeo/features/focus_session/presentation/providers/focus_session_controller.dart';
import 'package:homeo/features/focus_session/presentation/providers/focus_session_providers.dart';
import 'package:homeo/features/focus_session/presentation/widgets/streak_card.dart';
import 'package:homeo/l10n/l10n.dart';
import 'package:intl/intl.dart';

/// Focus tab, idle phase: greeting, streak, "start" card, today's numbers.
class FocusHomeView extends ConsumerWidget {
  const FocusHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    final stats = ref.watch(focusStatsProvider);
    final now = ref.watch(clockProvider).now();
    final locale = Localizations.localeOf(context).toString();

    final greeting = now.hour < 12
        ? l10n.greetingMorning
        : now.hour < 17
        ? l10n.greetingAfternoon
        : l10n.greetingEvening;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.xl,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
        children: [
          Text(
            DateFormat.MMMMEEEEd(locale).format(now),
            style: text.bodySmall?.copyWith(color: colors.inkMuted),
          ),
          Text(greeting, style: text.headlineMedium),
          const SizedBox(height: AppSpacing.xl),
          StreakCard(streak: stats.streak),
          const SizedBox(height: AppSpacing.lg),
          _StartCard(
            onStart: () =>
                ref.read(focusSessionControllerProvider.notifier).openSetup(),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _StatTile(
                  value: formatFocusDuration(l10n, stats.focusToday),
                  label: l10n.statFocusToday,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _StatTile(
                  value: formatFocusDuration(l10n, stats.focusThisWeek),
                  label: l10n.statFocusWeek,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _StatTile(
                  value: '${stats.sessionsToday}',
                  label: l10n.statSessionsToday,
                ),
              ),
            ],
          ),
          if (stats.lastSession != null) ...[
            const SizedBox(height: AppSpacing.lg),
            _LastSessionCard(session: stats.lastSession!),
          ],
        ],
      ),
    );
  }
}

class _StartCard extends StatelessWidget {
  const _StartCard({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = AppColors.of(context);
    final text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: AppRadius.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.focusPrompt,
            style: text.titleMedium?.copyWith(color: colors.onPrimary),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Inverted button: readable on the primary card in both themes.
          FilledButton(
            onPressed: onStart,
            style: FilledButton.styleFrom(
              backgroundColor: colors.onPrimary,
              foregroundColor: colors.primary,
            ),
            child: Text(l10n.focusStartCta),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(value, style: text.titleMedium),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(label, style: text.bodySmall?.copyWith(color: colors.inkMuted)),
        ],
      ),
    );
  }
}

class _LastSessionCard extends StatelessWidget {
  const _LastSessionCard({required this.session});

  final FocusSession session;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    final completed = session.status == FocusSessionStatus.completed;
    final intention = session.intention.isEmpty
        ? l10n.lastSessionNoIntention
        : session.intention;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Icon(
            completed ? Icons.check_circle_rounded : Icons.schedule_rounded,
            color: completed ? colors.success : colors.inkMuted,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.lastSessionTitle(
                    formatFocusDuration(l10n, session.actualDuration),
                  ),
                  style: text.titleSmall,
                ),
                Text(
                  intention,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text.bodySmall?.copyWith(color: colors.inkMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
