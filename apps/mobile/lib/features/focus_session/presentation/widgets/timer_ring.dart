import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:homeo/core/theme/app_colors.dart';
import 'package:homeo/core/theme/app_text_styles.dart';

/// Circular countdown. [progress] is 1.0 at the start and 0.0 at the end.
///
/// Screen readers get one summary label ([semanticsLabel]) instead of a
/// number that changes every second.
class TimerRing extends StatelessWidget {
  const TimerRing({
    required this.progress,
    required this.timeLabel,
    required this.statusLabel,
    required this.semanticsLabel,
    required this.isPaused,
    this.size = 256,
    super.key,
  });

  final double progress;
  final String timeLabel;
  final String statusLabel;
  final String semanticsLabel;
  final bool isPaused;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final strokeWidth = size * 0.055;

    return Semantics(
      label: semanticsLabel,
      child: ExcludeSemantics(
        child: SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween<double>(end: progress.clamp(0.0, 1.0)),
                // Glide between the once-per-second updates (ease: linear).
                duration: (isPaused || reduceMotion)
                    ? Duration.zero
                    : const Duration(seconds: 1),
                builder: (context, value, _) => CustomPaint(
                  size: Size.square(size),
                  painter: _RingPainter(
                    progress: value,
                    trackColor: colors.focusSurface,
                    progressColor: isPaused ? colors.accent : colors.primary,
                    strokeWidth: strokeWidth,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(size * 0.16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        timeLabel,
                        style: AppTextStyles.timer.copyWith(color: colors.ink),
                      ),
                    ),
                    Text(
                      statusLabel,
                      style: text.labelMedium?.copyWith(color: colors.inkMuted),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  final double progress;
  final Color trackColor;
  final Color progressColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = trackColor,
    );

    if (progress <= 0) return;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = strokeWidth
        ..color = progressColor,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress ||
      old.trackColor != trackColor ||
      old.progressColor != progressColor ||
      old.strokeWidth != strokeWidth;
}
