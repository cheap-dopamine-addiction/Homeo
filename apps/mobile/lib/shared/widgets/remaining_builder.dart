import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeo/core/time/clock.dart';

/// Rebuilds ~4×/s with the time left until [until].
///
/// Reads the injected [Clock] on every build instead of counting ticks, so it
/// stays right after the app was suspended and cannot be sped up or slowed
/// down by timer jitter.
class RemainingBuilder extends ConsumerStatefulWidget {
  const RemainingBuilder({
    required this.until,
    required this.builder,
    super.key,
  });

  final DateTime until;
  final Widget Function(BuildContext context, Duration remaining) builder;

  @override
  ConsumerState<RemainingBuilder> createState() => _RemainingBuilderState();
}

class _RemainingBuilderState extends ConsumerState<RemainingBuilder> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didUpdateWidget(RemainingBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.until != widget.until) _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 250), (timer) {
      if (_remaining() <= Duration.zero) timer.cancel();
      setState(() {});
    });
  }

  Duration _remaining() {
    final left = widget.until.difference(ref.read(clockProvider).now());
    return left.isNegative ? Duration.zero : left;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _remaining());
}
