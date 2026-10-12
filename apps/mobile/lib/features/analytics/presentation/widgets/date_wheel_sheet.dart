import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homeo/core/theme/app_colors.dart';
import 'package:homeo/core/utils/localized_text.dart';
import 'package:homeo/shared/widgets/app_ui.dart';
import 'package:intl/intl.dart';

String formatDateLabel(BuildContext context, DateTime d) {
  final locale = Localizations.localeOf(context).toString();
  return DateFormat.yMMMd(locale).format(d);
}

/// Day · month · year wheels (design: `DatePickerModal`). Returns null when
/// dismissed.
Future<DateTime?> showDateWheelSheet(
  BuildContext context, {
  required DateTime initial,
}) =>
    showHomeoSheet<DateTime>(context, (_) => _DateWheelSheet(initial: initial));

class _DateWheelSheet extends StatefulWidget {
  const _DateWheelSheet({required this.initial});

  final DateTime initial;

  @override
  State<_DateWheelSheet> createState() => _DateWheelSheetState();
}

class _DateWheelSheetState extends State<_DateWheelSheet> {
  late final List<int> _years;
  late int _day = widget.initial.day;
  late int _month = widget.initial.month;
  late int _year = widget.initial.year;

  late final FixedExtentScrollController _dayCtl;
  late final FixedExtentScrollController _monthCtl;
  late final FixedExtentScrollController _yearCtl;

  @override
  void initState() {
    super.initState();
    final y = DateTime.now().year;
    _years = [for (var i = y - 3; i <= y + 1; i++) i];
    if (!_years.contains(_year)) _year = y;
    _dayCtl = FixedExtentScrollController(initialItem: _day - 1);
    _monthCtl = FixedExtentScrollController(initialItem: _month - 1);
    _yearCtl = FixedExtentScrollController(initialItem: _years.indexOf(_year));
  }

  @override
  void dispose() {
    _dayCtl.dispose();
    _monthCtl.dispose();
    _yearCtl.dispose();
    super.dispose();
  }

  int get _daysInMonth => DateTime(_year, _month + 1, 0).day;

  DateTime get _value => DateTime(_year, _month, _day.clamp(1, _daysInMonth));

  void _clampDay() {
    if (_day > _daysInMonth) {
      _day = _daysInMonth;
      _dayCtl.jumpToItem(_day - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final locale = Localizations.localeOf(context).toString();
    final months = [
      for (var m = 1; m <= 12; m++)
        DateFormat.MMM(locale).format(DateTime(2000, m)),
    ];
    final style = Theme.of(context).textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
      color: c.ink,
    );

    Widget wheel(
      FixedExtentScrollController ctl,
      List<String> items,
      ValueChanged<int> onChanged,
      double width,
    ) {
      return SizedBox(
        width: width,
        child: CupertinoPicker(
          scrollController: ctl,
          itemExtent: 40,
          selectionOverlay: Container(
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(color: c.border, width: 1.5),
              ),
            ),
          ),
          onSelectedItemChanged: onChanged,
          children: [
            for (final i in items) Center(child: Text(i, style: style)),
          ],
        ),
      );
    }

    return SheetFrame(
      title: context.tx('เลือกวันที่', 'Choose a date'),
      onClose: () => Navigator.of(context).pop(),
      children: [
        SizedBox(
          height: 180,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              wheel(
                _dayCtl,
                [for (var i = 1; i <= 31; i++) i.toString().padLeft(2, '0')],
                (i) => setState(() => _day = i + 1),
                64,
              ),
              wheel(_monthCtl, months, (i) {
                setState(() {
                  _month = i + 1;
                  _clampDay();
                });
              }, 90),
              wheel(_yearCtl, [for (final y in _years) '$y'], (i) {
                setState(() {
                  _year = _years[i];
                  _clampDay();
                });
              }, 80),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GradientButton(
          label:
              '${context.tx('ยืนยัน', 'Confirm')} ${formatDateLabel(context, _value)}',
          onPressed: () => Navigator.of(context).pop(_value),
        ),
      ],
    );
  }
}
