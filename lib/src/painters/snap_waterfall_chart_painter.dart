import 'package:flutter/material.dart';
import '../models/snap_waterfall_data.dart';
import '../models/snap_style.dart';

class SnapWaterfallChartPainter extends CustomPainter {
  final List<SnapWaterfallBar> bars;
  final double animationValue;
  final Color positiveColor;
  final Color negativeColor;
  final Color totalColor;
  final double borderRadius;
  final double spacing;
  final SnapChartStyle style;
  final int? touchedIndex;

  SnapWaterfallChartPainter({
    required this.bars,
    required this.animationValue,
    required this.positiveColor,
    required this.negativeColor,
    required this.totalColor,
    required this.borderRadius,
    required this.spacing,
    required this.style,
    this.touchedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (bars.isEmpty) return;

    if (style.backgroundColor != null) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = style.backgroundColor!,
      );
    }

    if (style.showGrid) {
      _drawGrid(canvas, size);
    }

    // Calculate cumulative values and bounds
    final cumulativeValues = <double>[0];
    double runningTotal = 0;
    double maxVal = 0;
    double minVal = 0;

    for (final bar in bars) {
      if (bar.isTotal) {
        cumulativeValues.add(runningTotal);
      } else {
        runningTotal += bar.value;
        cumulativeValues.add(runningTotal);
      }
      if (runningTotal > maxVal) maxVal = runningTotal;
      if (runningTotal < minVal) minVal = runningTotal;
    }

    final range = maxVal - minVal;
    if (range == 0) return;
    final padding = range * 0.1;
    final totalRange = range + padding * 2;
    final zeroY = size.height * (maxVal + padding) / totalRange;

    final barCount = bars.length;
    final slotWidth = size.width / barCount;
    final barWidth = slotWidth * (1 - spacing);

    double cumulative = 0;

    for (int i = 0; i < barCount; i++) {
      final bar = bars[i];
      final isTouched = touchedIndex == i;

      Color color;
      double startVal;
      double endVal;

      if (bar.isTotal) {
        color = bar.color ?? totalColor;
        startVal = 0;
        endVal = cumulative;
      } else {
        color = bar.color ?? (bar.value >= 0 ? positiveColor : negativeColor);
        startVal = cumulative;
        endVal = cumulative + bar.value;
        cumulative += bar.value;
      }

      final startY =
          zeroY - (startVal / totalRange * size.height) * animationValue;
      final endY = zeroY - (endVal / totalRange * size.height) * animationValue;
      final top = startY < endY ? startY : endY;
      final height = (startY - endY).abs().clamp(1.0, double.infinity);

      final left = i * slotWidth + (slotWidth - barWidth) / 2;
      final actualColor = isTouched ? color.withValues(alpha: 0.7) : color;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, barWidth, height),
        Radius.circular(borderRadius),
      );
      canvas.drawRRect(rect, Paint()..color = actualColor);

      // Connector line to next bar
      if (i < barCount - 1 && !bars[i + 1].isTotal) {
        canvas.drawLine(
          Offset(left + barWidth, endY),
          Offset(left + slotWidth, endY),
          Paint()
            ..color = style.gridColor
            ..strokeWidth = 0.5
            ..style = PaintingStyle.stroke,
        );
      }

      // Label
      if (style.showLabels && bar.label != null) {
        final textStyle = style.labelStyle ??
            const TextStyle(color: Colors.grey, fontSize: 10);
        final textSpan = TextSpan(text: bar.label, style: textStyle);
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        )..layout();
        final x = i * slotWidth + (slotWidth - textPainter.width) / 2;
        textPainter.paint(
            canvas, Offset(x, size.height - textPainter.height - 2));
      }
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = style.gridColor
      ..strokeWidth = 0.5;

    const gridLines = 5;
    for (int i = 0; i <= gridLines; i++) {
      final y = size.height * i / gridLines;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant SnapWaterfallChartPainter oldDelegate) => true;
}
