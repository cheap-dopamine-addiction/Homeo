import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeo/core/theme/app_colors.dart';
import 'package:homeo/core/time/clock.dart';
import 'package:homeo/core/utils/localized_text.dart';
import 'package:homeo/features/analytics/domain/export_builder.dart';
import 'package:homeo/features/analytics/presentation/providers/insights_providers.dart';
import 'package:homeo/features/analytics/presentation/widgets/date_wheel_sheet.dart';
import 'package:homeo/features/focus_session/domain/focus_session.dart';
import 'package:homeo/features/focus_session/presentation/providers/focus_session_providers.dart';
import 'package:homeo/features/friction/domain/blocked_app.dart';
import 'package:homeo/features/friction/domain/distraction_event.dart';
import 'package:homeo/features/friction/presentation/providers/friction_providers.dart';
import 'package:homeo/features/settings/data/settings_repository.dart';
import 'package:homeo/features/settings/domain/user_settings.dart';
import 'package:homeo/features/vault_partner/presentation/providers/vault_controller.dart';
import 'package:homeo/shared/widgets/app_ui.dart';

/// "Export data" sheet (design: `ExportFlow.tsx`): pick format + range,
/// prepare, done. [offline] shows the no-connection state from the design.
Future<void> showExportFlow(BuildContext context, {bool offline = false}) =>
    showHomeoSheet<void>(context, (_) => ExportFlow(offline: offline));

enum _Phase { pick, loading, done }

class ExportFlow extends ConsumerStatefulWidget {
  const ExportFlow({this.offline = false, super.key});

  final bool offline;

  @override
  ConsumerState<ExportFlow> createState() => _ExportFlowState();
}

class _ExportFlowState extends ConsumerState<ExportFlow> {
  ExportFormat _format = ExportFormat.csv;
  ExportRange _range = ExportRange.days7;
  _Phase _phase = _Phase.pick;
  String _content = '';
  late DateTime _customStart;
  late DateTime _customEnd;
  Timer? _dotsTimer;
  int _dots = 1;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _customEnd = DateTime(today.year, today.month, today.day);
    _customStart = DateTime(today.year, today.month, today.day - 13);
  }

  @override
  void dispose() {
    _dotsTimer?.cancel();
    super.dispose();
  }

  Future<void> _start() async {
    final today = ref.read(clockProvider).now();
    final range = ExportBuilder.rangeFor(
      _range,
      today,
      customStart: _customStart,
      customEnd: _customEnd,
    );
    final sessions =
        ref.read(finishedSessionsProvider).value ?? const <FocusSession>[];
    final events =
        ref.read(distractionEventsProvider).value ??
        const <DistractionEvent>[];
    final blocked =
        ref.read(blockedAppsProvider).value ?? const <BlockedApp>[];
    final settings =
        ref.read(userSettingsProvider).value ?? UserSettings.defaults;
    final partners = [
      for (final p in ref.read(vaultControllerProvider).partners)
        {
          'name': p.name,
          'status': p.status.name,
          'permissions': [for (final x in p.permissions) x.name],
        },
    ];

    setState(() => _phase = _Phase.loading);
    _dotsTimer = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) => setState(() => _dots = _dots >= 3 ? 1 : _dots + 1),
    );

    _content = ExportBuilder.build(
      format: _format,
      range: range,
      sessions: sessions,
      events: events,
      blockedApps: blocked,
      settings: settings,
      partners: partners,
    );
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    _dotsTimer?.cancel();
    setState(() => _phase = _Phase.done);
  }

  Future<void> _copy() async {
    final messenger = ScaffoldMessenger.of(context);
    final msg = context.tx('คัดลอกข้อมูลแล้ว', 'Data copied');
    await Clipboard.setData(ClipboardData(text: _content));
    if (!mounted) return;
    Navigator.of(context).pop();
    messenger.showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    final title = context.tx('ส่งออกข้อมูล', 'Export data');
    void close() => Navigator.of(context).pop();
    final name = ExportBuilder.fileName(_format, ref.read(clockProvider).now());

    if (widget.offline) {
      return SheetFrame(
        title: title,
        onClose: close,
        children: [
          _CenterStatus(
            icon: Icons.wifi_off_rounded,
            color: c.inkMuted,
            title: context.tx(
              'ไม่มีการเชื่อมต่ออินเทอร์เน็ต',
              'No internet connection',
            ),
            body: context.tx(
              'ต้องเชื่อมต่ออินเทอร์เน็ตเพื่อ export ข้อมูล',
              'You need an internet connection to export data',
            ),
          ),
          SoftButton(label: context.tx('ปิด', 'Close'), onPressed: close),
        ],
      );
    }

    if (_phase == _Phase.loading) {
      return SheetFrame(
        title: title,
        onClose: close,
        children: [
          _CenterStatus(
            icon: Icons.download_rounded,
            color: c.primary,
            title:
                '${context.tx('กำลังเตรียม', 'Preparing')} ${_format.name.toUpperCase()}${'.' * _dots}',
            body: name,
          ),
        ],
      );
    }

    if (_phase == _Phase.done) {
      return SheetFrame(
        title: title,
        onClose: close,
        children: [
          _CenterStatus(
            icon: Icons.check_rounded,
            color: c.success,
            title: context.tx('พร้อมแล้ว!', 'Ready!'),
            body: '$name.${_format.extension}',
          ),
          GradientButton(
            label: context.tx('คัดลอกข้อมูล', 'Copy data'),
            icon: Icons.copy_rounded,
            onPressed: _copy,
          ),
          const SizedBox(height: 10),
          SoftButton(label: context.tx('ปิด', 'Close'), onPressed: close),
        ],
      );
    }

    final formats = <(ExportFormat, String, String, String)>[
      (ExportFormat.pdf, 'PDF', 'สรุปพร้อมกราฟ', 'Summary with charts'),
      (ExportFormat.csv, 'CSV', 'ข้อมูลดิบสำหรับ spreadsheet', 'Raw data for spreadsheets'),
      (ExportFormat.json, 'JSON', 'settings, แอปบล็อก, partner', 'Settings, blocked apps, partners'),
      (ExportFormat.markdown, 'Markdown', 'สรุปรายวัน + insights', 'Daily summary + insights'),
      (ExportFormat.png, 'PNG', 'กราฟการใช้งานและ focus trend', 'Usage charts and focus trend'),
    ];
    final ranges = <(ExportRange, String, String)>[
      (ExportRange.days7, '7 วันล่าสุด', 'Last 7 days'),
      (ExportRange.days30, '30 วันล่าสุด', 'Last 30 days'),
      (ExportRange.thisMonth, 'เดือนนี้', 'This month'),
      (ExportRange.custom, 'กำหนดเอง', 'Custom'),
    ];

    return SheetFrame(
      title: title,
      onClose: close,
      children: [
        SectionLabel(context.tx('รูปแบบ', 'Format')),
        const SizedBox(height: 8),
        for (final f in formats) ...[
          Semantics(
            button: true,
            selected: _format == f.$1,
            enabled: f.$1.supported,
            child: Material(
              color: _format == f.$1 ? c.primarySoft : c.surface,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: f.$1.supported
                    ? () => setState(() => _format = f.$1)
                    : null,
                child: Opacity(
                  opacity: f.$1.supported ? 1 : 0.55,
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 56),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _format == f.$1 ? c.primary : c.border,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        IconTile(
                          icon: Icons.description_outlined,
                          size: 36,
                          background: _format == f.$1 ? c.surface : c.surfaceAlt,
                          color: _format == f.$1 ? c.primary : c.inkMuted,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                f.$2,
                                style: text.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                f.$1.supported
                                    ? context.tx(f.$3, f.$4)
                                    : context.tx(
                                        'เร็ว ๆ นี้',
                                        'Coming soon',
                                      ),
                                style: text.bodySmall?.copyWith(
                                  color: c.inkMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_format == f.$1)
                          Icon(Icons.check_rounded, color: c.primary),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 8),
        SectionLabel(context.tx('ช่วงเวลา', 'Date range')),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final r in ranges)
              PillChoice(
                label: context.tx(r.$2, r.$3),
                selected: _range == r.$1,
                height: 40,
                onTap: () => setState(() => _range = r.$1),
              ),
          ],
        ),
        if (_range == ExportRange.custom) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: SoftButton(
                  label: formatDateLabel(context, _customStart),
                  icon: Icons.calendar_today_outlined,
                  onPressed: () async {
                    final d = await showDateWheelSheet(
                      context,
                      initial: _customStart,
                    );
                    if (d != null) setState(() => _customStart = d);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(context.tx('ถึง', 'to')),
              ),
              Expanded(
                child: SoftButton(
                  label: formatDateLabel(context, _customEnd),
                  icon: Icons.calendar_today_outlined,
                  onPressed: () async {
                    final d = await showDateWheelSheet(
                      context,
                      initial: _customEnd,
                    );
                    if (d != null) setState(() => _customEnd = d);
                  },
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 12),
        Text.rich(
          TextSpan(
            text: context.tx('ชื่อไฟล์: ', 'File name: '),
            children: [
              TextSpan(
                text: name,
                style: TextStyle(
                  color: c.primaryText,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          style: text.bodySmall?.copyWith(color: c.inkMuted),
        ),
        const SizedBox(height: 12),
        GradientButton(
          label: '${context.tx('ส่งออก', 'Export')} ${_format.name.toUpperCase()}',
          onPressed: _format.supported ? _start : null,
        ),
      ],
    );
  }
}

class _CenterStatus extends StatelessWidget {
  const _CenterStatus({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: c.surfaceAlt,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(icon, size: 30, color: color),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: text.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            textAlign: TextAlign.center,
            style: text.bodySmall?.copyWith(color: c.inkMuted),
          ),
        ],
      ),
    );
  }
}
