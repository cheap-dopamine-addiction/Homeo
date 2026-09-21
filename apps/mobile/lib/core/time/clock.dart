import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'clock.g.dart';

/// Injectable time source. Every timer/cooling-off rule reads time through
/// this so behavioural tests (PRD §30.3) can control it.
abstract interface class Clock {
  DateTime now();
}

final class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now();
}

@Riverpod(keepAlive: true)
Clock clock(Ref ref) => const SystemClock();
