import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Thin abstraction over [DateTime.now()] so tests can inject a fake clock.
abstract class Clock {
  /// Returns the current [DateTime] in local time.
  DateTime now();

  /// Returns the current UTC [DateTime].
  DateTime nowUtc() => now().toUtc();
}

/// Production implementation — delegates straight to [DateTime.now()].
class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now();
}

/// Riverpod provider for [Clock].
///
/// Override in tests with a [FakeClock] via [ProviderScope] overrides.
final clockProvider = Provider<Clock>(
  (ref) => const SystemClock(),
  name: 'clockProvider',
);

// ---------------------------------------------------------------------------
// Testing helpers (can be imported in test files)
// ---------------------------------------------------------------------------

/// A [Clock] whose current time is fixed — useful for deterministic unit tests.
class FakeClock implements Clock {
  FakeClock(this._now);

  DateTime _now;

  @override
  DateTime now() => _now;

  /// Advance the clock by [duration].
  void advance(Duration duration) => _now = _now.add(duration);

  /// Set the clock to an arbitrary point in time.
  void set(DateTime time) => _now = time;
}
