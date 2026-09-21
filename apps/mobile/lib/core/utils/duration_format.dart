import 'package:homeo/l10n/l10n.dart';

/// `mm:ss`, or `hh:mm:ss` once past an hour. Digits only, so it is
/// locale-independent (used for the countdown and the start button).
String formatClock(Duration duration) {
  final total = duration.inSeconds < 0 ? 0 : duration.inSeconds;
  final h = total ~/ 3600;
  final m = (total % 3600) ~/ 60;
  final s = total % 60;
  String two(int n) => n.toString().padLeft(2, '0');
  return h > 0 ? '${two(h)}:${two(m)}:${two(s)}' : '${two(m)}:${two(s)}';
}

/// Human readable, localised: "1 ชม. 20 น." / "1h 20m".
String formatFocusDuration(AppLocalizations l10n, Duration duration) {
  final totalMinutes = duration.inMinutes;
  final hours = totalMinutes ~/ 60;
  final minutes = totalMinutes % 60;
  if (hours > 0 && minutes > 0) {
    return l10n.durationHoursMinutes(hours, minutes);
  }
  if (hours > 0) return l10n.durationHoursOnly(hours);
  return l10n.durationMinutesOnly(minutes);
}
