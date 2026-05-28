import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/snap_gauge_data.dart';
import '../models/snap_style.dart';

class SnapGaugeChartPainter extends CustomPainter {
  final SnapGaugeData data;
  final double animationValue;
  final SnapChartStyle style;

  SnapGaugeChartPainter({
    required this.data,
    required this.animationValue,
    required this.style,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.7);
    final radius = size.shortestSide * 0.4;
    const startAngle = math.pi * 0.8;
    const sweepAngle = math.pi * 1.4;
    final arcWidth = radius * 0.2;

    // Draw background arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      Paint()
        ..color = style.gridColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = arcWidth
        ..strokeCap = StrokeCap.round,
    );

    // Draw segments
    if (data.segments.isNotEmpty) {
      final range = data.max - data.min;
      for (final segment in data.segments) {
        final segStart =
            startAngle + (segment.from - data.min) / range * sweepAngle;
        final segSweep = (segment.to - segment.from) / range * sweepAngle;
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          segStart,
          segSweep * animationValue,
          false,
          Paint()
            ..color = segment.color
            ..style = PaintingStyle.stroke
            ..strokeWidth = arcWidth
            ..strokeCap = StrokeCap.butt,
        );
      }
    } else {
      // Single color progress
      final progress = (data.value - data.min) / (data.max - data.min);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle * progress.clamp(0, 1) * animationValue,
        false,
        Paint()
          ..color = data.needleColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = arcWidth
          ..strokeCap = StrokeCap.round,
      );
    }

    // Draw needle
    final progress =
        ((data.value - data.min) / (data.max - data.min)).clamp(0.0, 1.0);
    final needleAngle = startAngle + sweepAngle * progress * animationValue;
    final needleLength = radius * 0.75;
    final needleEnd = Offset(
      center.dx + math.cos(needleAngle) * needleLength,
      center.dy + math.sin(needleAngle) * needleLength,
    );

    canvas.drawLine(
      center,
      needleEnd,
      Paint()
        ..color = data.needleColor
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );

    // Center dot
    canvas.drawCircle(center, 5, Paint()..color = data.needleColor);

    // Value text
    if (data.showValue) {
      final valueText = data.value.toStringAsFixed(1);
      final textStyle = style.labelStyle ??
          TextStyle(
            color: data.needleColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          );
      final textSpan = TextSpan(text: valueText, style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        Offset(center.dx - textPainter.width / 2, center.dy + 15),
      );
    }

    // Label
    if (data.label != null) {
      final labelStyle =
          style.labelStyle ?? const TextStyle(color: Colors.grey, fontSize: 12);
      final labelSpan = TextSpan(text: data.label, style: labelStyle);
      final labelPainter = TextPainter(
        text: labelSpan,
        textDirection: TextDirection.ltr,
      )..layout();
      labelPainter.paint(
        canvas,
        Offset(center.dx - labelPainter.width / 2, center.dy + 38),
      );
    }
  }

  @override
  bool shouldRepaint(covariant SnapGaugeChartPainter oldDelegate) => true;
}
