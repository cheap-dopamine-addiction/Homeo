import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeo/core/theme/app_colors.dart';
import 'package:homeo/core/time/clock.dart';
import 'package:homeo/core/utils/localized_text.dart';
import 'package:homeo/features/analytics/domain/insights_calculator.dart';
import 'package:homeo/features/analytics/presentation/providers/insights_providers.dart';
import 'package:homeo/features/analytics/presentation/widgets/date_wheel_sheet.dart';
import 'package:homeo/features/analytics/presentation/widgets/export_flow.dart';
import 'package:homeo/features/focus_session/domain/focus_session.dart';
import 'package:homeo/features/focus_session/presentation/providers/focus_session_providers.dart';
import 'package:homeo/features/friction/domain/app_catalog.dart';
import 'package:homeo/features/friction/domain/distraction_event.dart';
import 'package:homeo/shared/widgets/app_ui.dart';
import 'package:intl/intl.dart';

/// Insights tab (design: `InsightsScreen.tsx`), driven by the local focus
/// sessions and distraction log instead of mock numbers.
class InsightsScreen extends ConsumerStatefulWidget {
  const InsightsScreen({super.key});

  @override
  ConsumerState<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends ConsumerState<InsightsScreen> {
  InsightsPeriod _period = InsightsPeriod.week;
  late DateTime _selected;
  late DateTime _customStart;
  late DateTime _customEnd;
  String? _expandedApp;
  final Set<String> _dismissed = {};

  @override
  void initState() {
    super.initState();
    final t = InsightsCalculator.dayOf(DateTime.now());
    _selected = t;
    _customEnd = t;
    _customStart = DateTime(t.year, t.month, t.day - 13);
  }

  DateTime get _today =>
      InsightsCalculator.dayOf(ref.read(clockProvider).now());

  bool get _isToday => _selected == _today;

  DateTime _offset(DateTime d, int delta) =>
      DateTime(d.year, d.month, d.day + delta);

  Future<void> _pick(DateTime initial, ValueChanged<DateTime> apply) async {
    final d = await showDateWheelSheet(context, initial: initial);
    if (d != null) setState(() => apply(InsightsCalculator.dayOf(d)));
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    final sessions =
        ref.watch(finishedSessionsProvider).value ?? const <FocusSession>[];
    final events =
        ref.watch(distractionEventsProvider).value ??
        const <DistractionEvent>[];
    final streak = ref.watch(focusStatsProvider).streak.current;

    final range = InsightsCalculator.rangeFor(
      _period,
      _selected,
      customStart: _customStart,
      customEnd: _customEnd,
    );
    final data = InsightsCalculator.compute(
      range: range,
      finishedSessions: sessions,
      events: events,
    );
    final timeline = InsightsCalculator.timeline(
      day: _selected,
      finishedSessions: sessions,
      events: events,
    );
    final insights = [
      for (final i in data.insights)
        if (!_dismissed.contains(i.id)) i,
    ];
    final dateLabel =
        formatDateLabel(context, _selected) +
        (_isToday ? ' · ${context.tx('วันนี้', 'Today')}' : '');

    final periods = <(InsightsPeriod, String, String)>[
      (InsightsPeriod.week, 'สัปดาห์', 'Week'),
      (InsightsPeriod.month, 'เดือน', 'Month'),
      (InsightsPeriod.threeMonth, '3 เดือน', '3 months'),
      (InsightsPeriod.custom, 'กำหนดเอง', 'Custom'),
    ];
    final periodDays = switch (_period) {
      InsightsPeriod.week => 7,
      InsightsPeriod.month => 30,
      InsightsPeriod.threeMonth => 90,
      InsightsPeriod.custom => range.days,
    };
    final exportLabel = switch (_period) {
      InsightsPeriod.custom => context.tx('ช่วงที่เลือก', 'selected range'),
      InsightsPeriod.week => context.tx('สัปดาห์นี้', 'this week'),
      InsightsPeriod.month => context.tx('เดือนนี้', 'this month'),
      InsightsPeriod.threeMonth => context.tx('3 เดือน', '3 months'),
    };
    final focusLabel = _period == InsightsPeriod.custom
        ? context.tx('โฟกัสรวม', 'Total focus')
        : context.tx('โฟกัสรวม $periodDays วัน', 'Focus · $periodDays days');

    return SafeArea(
      child: Column(
        children: [
          // Header: prev day · title/date · next day
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Row(
              children: [
                IconButton(
                  tooltip: context.tx('วันก่อนหน้า', 'Previous day'),
                  onPressed: () =>
                      setState(() => _selected = _offset(_selected, -1)),
                  icon: const Icon(Icons.chevron_left_rounded),
                ),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _pick(_selected, (d) => _selected = d),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Insights',
                                style: text.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 14,
                                color: c.primary,
                              ),
                            ],
                          ),
                          Text(
                            dateLabel,
                            style: text.bodySmall?.copyWith(color: c.inkMuted),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                IconButton(
                  tooltip: context.tx('วันถัดไป', 'Next day'),
                  onPressed: _isToday
                      ? null
                      : () => setState(() => _selected = _offset(_selected, 1)),
                  icon: const Icon(Icons.chevron_right_rounded),
                ),
              ],
            ),
          ),
          // Period selector
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: c.surfaceAlt,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                children: [
                  for (final p in periods)
                    Expanded(
                      child: Semantics(
                        button: true,
                        selected: _period == p.$1,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(999),
                          onTap: () => setState(() => _period = p.$1),
                          child: Container(
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _period == p.$1
                                  ? c.surface
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              context.tx(p.$2, p.$3),
                              style: text.labelMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: _period == p.$1
                                    ? c.primaryText
                                    : c.inkMuted,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (_period == InsightsPeriod.custom)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Row(
                children: [
                  Text(
                    context.tx('ตั้งแต่', 'From'),
                    style: text.bodySmall?.copyWith(color: c.inkMuted),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: SoftButton(
                      label: formatDateLabel(context, _customStart),
                      icon: Icons.calendar_today_outlined,
                      height: 40,
                      onPressed: () =>
                          _pick(_customStart, (d) => _customStart = d),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    context.tx('ถึง', 'to'),
                    style: text.bodySmall?.copyWith(color: c.inkMuted),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: SoftButton(
                      label: formatDateLabel(context, _customEnd),
                      icon: Icons.calendar_today_outlined,
                      height: 40,
                      onPressed: () => _pick(_customEnd, (d) => _customEnd = d),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              children: [
                if (_period != InsightsPeriod.custom)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Expanded(child: Divider(color: c.border)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            context.tx(
                              '$periodDays วันล่าสุด',
                              'Last $periodDays days',
                            ),
                            style: text.labelSmall?.copyWith(
                              color: c.inkSubtle,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: c.border)),
                      ],
                    ),
                  ),
                // Stat cards
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.35,
                  children: [
                    _StatCard(
                      label: focusLabel,
                      value: NumberFormat.decimalPattern().format(
                        data.focusMinutes,
                      ),
                      unit: context.tx('นาที', 'min'),
                      color: c.primary,
                    ),
                    _StatCard(
                      label: context.tx('Sessions เฉลี่ย', 'Avg. sessions'),
                      value: data.sessionsPerDay.toStringAsFixed(
                        data.sessionsPerDay ==
                                data.sessionsPerDay.roundToDouble()
                            ? 0
                            : 1,
                      ),
                      unit: context.tx('ครั้ง/วัน', 'per day'),
                      color: c.ink,
                    ),
                    _StatCard(
                      label: 'Streak',
                      value: '$streak',
                      unit: context.tx('วัน', 'days'),
                      color: c.accentText,
                    ),
                    _DliCard(value: data.dli),
                  ],
                ),
                const SizedBox(height: 20),
                SectionLabel(
                  _period == InsightsPeriod.custom
                      ? 'App Usage'
                      : 'App Usage · ${context.tx('$periodDays วัน', '$periodDays days')}',
                ),
                const SizedBox(height: 8),
                if (data.apps.isEmpty)
                  _EmptyCard(
                    context.tx(
                      'ยังไม่มีการพยายามเปิดแอปในช่วงนี้',
                      'No app-open attempts in this period',
                    ),
                  )
                else
                  SoftCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        for (var i = 0; i < data.apps.length; i++) ...[
                          if (i > 0) Divider(height: 1, color: c.rule),
                          _AppUsageRow(
                            usage: data.apps[i],
                            expanded: _expandedApp == data.apps[i].packageId,
                            onTap: () => setState(
                              () => _expandedApp =
                                  _expandedApp == data.apps[i].packageId
                                  ? null
                                  : data.apps[i].packageId,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
                SectionLabel('Session Timeline · $dateLabel'),
                const SizedBox(height: 8),
                if (timeline.isEmpty)
                  _EmptyCard(
                    context.tx(
                      'ยังไม่มีกิจกรรมในวันนี้',
                      'No activity on this day',
                    ),
                  )
                else
                  SoftCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        for (var i = 0; i < timeline.length; i++) ...[
                          if (i > 0) Divider(height: 1, color: c.rule),
                          _TimelineRow(entry: timeline[i]),
                        ],
                      ],
                    ),
                  ),
                if (insights.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  const SectionLabel('Smart Insights'),
                  const SizedBox(height: 8),
                  for (final ins in insights) ...[
                    _InsightRow(
                      insight: ins,
                      onDismiss: () => setState(() => _dismissed.add(ins.id)),
                    ),
                    const SizedBox(height: 8),
                  ],
                ],
                const SizedBox(height: 12),
                SoftButton(
                  label: 'Export $exportLabel',
                  icon: Icons.download_rounded,
                  height: 52,
                  onPressed: () => showExportFlow(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return SoftCard(
      child: Text(
        message,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: c.inkMuted),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  final String label;
  final String value;
  final String unit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    return SoftCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: text.labelSmall?.copyWith(
              color: c.inkMuted,
              fontWeight: FontWeight.w700,
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: text.headlineMedium?.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ),
          Text(unit, style: text.bodySmall?.copyWith(color: c.inkSubtle)),
        ],
      ),
    );
  }
}

class _DliCard extends StatelessWidget {
  const _DliCard({required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    final barColor = value < 40
        ? c.success
        : value < 70
        ? c.warn
        : c.danger;
    return SoftCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Dopamine Load Index',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: text.labelSmall?.copyWith(
              color: c.inkMuted,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            '$value',
            style: text.headlineMedium?.copyWith(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: barColor,
            ),
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: value / 100,
              minHeight: 6,
              color: barColor,
              backgroundColor: c.rule,
            ),
          ),
        ],
      ),
    );
  }
}

Color _levelBg(AppColorSet c, int level) => switch (level) {
  <= 1 => c.successSoft,
  2 => c.warnSoft,
  _ => c.dangerSoft,
};

Color _levelFg(AppColorSet c, int level) => switch (level) {
  <= 1 => c.success,
  2 => c.onWarnSoft,
  _ => c.onDangerSoft,
};

class _AppUsageRow extends StatelessWidget {
  const _AppUsageRow({
    required this.usage,
    required this.expanded,
    required this.onTap,
  });

  final AppUsage usage;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    final app = AppCatalog.byPackage(usage.packageId);
    final name = AppCatalog.nameOf(usage.packageId);
    final brand = app?.brand ?? c.primary;
    final last = DateFormat.Hm().format(usage.lastAt);

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                AppBadge(name: name, color: brand, size: 34),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: text.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        context.tx(
                          '${usage.attempts} ครั้ง',
                          '${usage.attempts} attempts',
                        ),
                        style: text.bodySmall?.copyWith(color: c.inkMuted),
                      ),
                    ],
                  ),
                ),
                Text(
                  context.tx(
                    '${usage.blocks} บล็อก',
                    '${usage.blocks} blocked',
                  ),
                  style: text.labelMedium?.copyWith(
                    color: c.success,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Icon(
                  expanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  color: c.inkSubtle,
                ),
              ],
            ),
          ),
        ),
        if (expanded)
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Pill(
                      label: context.tx('พยายาม', 'Attempts'),
                      value: '${usage.attempts}x',
                      fg: c.onWarnSoft,
                      bg: c.warnSoft,
                    ),
                    _Pill(
                      label: context.tx('บล็อก', 'Blocked'),
                      value: '${usage.blocks}x',
                      fg: c.success,
                      bg: c.successSoft,
                    ),
                    _Pill(
                      label: context.tx('ล่าสุด', 'Last'),
                      value: last,
                      fg: c.inkMuted,
                      bg: c.border,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _levelBg(c, usage.levelCode),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'L${usage.levelCode}',
                        style: text.labelSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: _levelFg(c, usage.levelCode),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  context.tx('รายชั่วโมง', 'By hour'),
                  style: text.labelSmall?.copyWith(color: c.inkMuted),
                ),
                const SizedBox(height: 6),
                _HourlyChart(data: usage.hourly, color: brand),
              ],
            ),
          ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.value,
    required this.fg,
    required this.bg,
  });

  final String label;
  final String value;
  final Color fg;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text.rich(
        TextSpan(
          text: '$value ',
          style: text.labelMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: fg,
          ),
          children: [
            TextSpan(
              text: label,
              style: text.labelSmall?.copyWith(color: fg),
            ),
          ],
        ),
      ),
    );
  }
}

class _HourlyChart extends StatelessWidget {
  const _HourlyChart({required this.data, required this.color});

  final List<int> data;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    final maxV = data.fold<int>(1, (m, v) => v > m ? v : m);
    const labels = ['8', '10', '12', '14', '16', '18', '20', '22'];
    return Column(
      children: [
        SizedBox(
          height: 48,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final v in data)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Container(
                      height: v == 0 ? 3 : 48 * v / maxV,
                      decoration: BoxDecoration(
                        color: v == 0 ? c.border : color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            for (final l in labels)
              Expanded(
                child: Text(
                  l,
                  textAlign: TextAlign.center,
                  style: text.labelSmall?.copyWith(
                    fontSize: 10,
                    color: c.inkSubtle,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.entry});

  final TimelineEntry entry;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    final app = AppCatalog.nameOf(entry.packageId);
    final level = 'L${entry.levelCode}';

    final (icon, color, label) = switch (entry.kind) {
      TimelineKind.focusCompleted => (
        Icons.check_circle_outline_rounded,
        c.success,
        context.tx(
          'Focus เสร็จ • ${entry.minutes} นาที',
          'Focus completed • ${entry.minutes} min',
        ),
      ),
      TimelineKind.focusEndedEarly => (
        Icons.schedule_rounded,
        c.inkMuted,
        context.tx(
          'ออกก่อนเวลา • ${entry.minutes} นาที',
          'Ended early • ${entry.minutes} min',
        ),
      ),
      TimelineKind.attemptReturned => (
        Icons.shield_outlined,
        c.success,
        context.tx(
          'พยายามเปิด $app • $level • กลับไปโฟกัส',
          'Tried to open $app • $level • returned to focus',
        ),
      ),
      TimelineKind.attemptNotified => (
        Icons.warning_amber_rounded,
        c.warn,
        context.tx('เปิด $app • แจ้งเตือนแล้ว', 'Opened $app • warned'),
      ),
      TimelineKind.attemptOpened => (
        Icons.warning_amber_rounded,
        c.warn,
        context.tx(
          'เปิด $app • $level friction',
          'Opened $app • $level friction',
        ),
      ),
      TimelineKind.override => (
        Icons.lock_open_rounded,
        c.accent,
        'Override • $app',
      ),
    };

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.Hm().format(entry.at),
                  style: text.labelSmall?.copyWith(
                    color: c.inkSubtle,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(label, style: text.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  const _InsightRow({required this.insight, required this.onDismiss});

  final SmartInsight insight;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    final app = AppCatalog.nameOf(insight.packageId);

    final (icon, color, label) = switch (insight.kind) {
      SmartInsightKind.bestHour => (
        Icons.bar_chart_rounded,
        c.primary,
        context.tx(
          'โฟกัสดีที่สุดช่วง ${insight.hour.toString().padLeft(2, '0')}:00–${((insight.hour + 2) % 24).toString().padLeft(2, '0')}:00',
          'Best focus around ${insight.hour.toString().padLeft(2, '0')}:00–${((insight.hour + 2) % 24).toString().padLeft(2, '0')}:00',
        ),
      ),
      SmartInsightKind.topApp => (
        Icons.smartphone_rounded,
        c.warn,
        context.tx(
          '$app กระตุ้น ${insight.count} ครั้ง',
          '$app tempted you ${insight.count} times',
        ),
      ),
      SmartInsightKind.frictionBlocks => (
        Icons.shield_outlined,
        c.success,
        context.tx(
          'Friction ช่วยให้กลับไปโฟกัส ${insight.count} ครั้ง',
          'Friction brought you back to focus ${insight.count} times',
        ),
      ),
    };

    return SoftCard(
      padding: const EdgeInsets.fromLTRB(14, 4, 4, 4),
      radius: 16,
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          IconButton(
            tooltip: context.tx('ปิด', 'Dismiss'),
            onPressed: onDismiss,
            icon: Icon(Icons.close_rounded, size: 18, color: c.inkSubtle),
          ),
        ],
      ),
    );
  }
}
