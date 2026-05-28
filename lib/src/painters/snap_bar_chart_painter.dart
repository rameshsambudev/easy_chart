import 'package:flutter/material.dart';
import '../models/snap_bar_data.dart';
import '../models/snap_style.dart';

class SnapBarChartPainter extends CustomPainter {
  final List<SnapBar> bars;
  final List<SnapBar> oldBars;
  final double animationValue;
  final Color defaultColor;
  final double borderRadius;
  final double spacing;
  final bool horizontal;
  final SnapChartStyle style;
  final int? touchedIndex;
  final double? maxValue;

  SnapBarChartPainter({
    required this.bars,
    required this.oldBars,
    required this.animationValue,
    required this.defaultColor,
    required this.borderRadius,
    required this.spacing,
    required this.horizontal,
    required this.style,
    this.touchedIndex,
    this.maxValue,
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

    final max = maxValue ?? _calculateMax();
    if (max == 0) return;

    final barCount = bars.length;
    final totalWidth = horizontal ? size.height : size.width;
    final totalHeight = horizontal ? size.width : size.height;
    final barSlotWidth = totalWidth / barCount;
    final barWidth = barSlotWidth * (1 - spacing);

    for (int i = 0; i < barCount; i++) {
      final bar = bars[i];
      final oldBar = i < oldBars.length ? oldBars[i] : bar;
      final color = bar.color ?? defaultColor;

      if (bar.isGrouped) {
        _drawGroupedBar(
            canvas, size, bar, i, barSlotWidth, barWidth, max, totalHeight);
      } else {
        final oldValue = oldBar.value;
        final newValue = bar.value;
        final value = oldValue + (newValue - oldValue) * animationValue;
        final barHeight = (value / max) * totalHeight;

        final isTouched = touchedIndex == i;
        final actualColor = isTouched ? color.withValues(alpha: 0.7) : color;

        final left = i * barSlotWidth + (barSlotWidth - barWidth) / 2;
        final top = totalHeight - barHeight;

        final rect = horizontal
            ? RRect.fromRectAndRadius(
                Rect.fromLTWH(0, left, barHeight, barWidth),
                Radius.circular(borderRadius),
              )
            : RRect.fromRectAndRadius(
                Rect.fromLTWH(left, top, barWidth, barHeight),
                Radius.circular(borderRadius),
              );

        canvas.drawRRect(rect, Paint()..color = actualColor);
      }

      if (style.showLabels && bar.label != null) {
        _drawLabel(canvas, size, bar.label!, i, barSlotWidth, totalHeight);
      }
    }
  }

  void _drawGroupedBar(Canvas canvas, Size size, SnapBar bar, int index,
      double slotWidth, double barWidth, double max, double totalHeight) {
    final groupCount = bar.allValues.length;
    final singleBarWidth = barWidth / groupCount;
    final defaultGroupColors = [
      defaultColor,
      defaultColor.withValues(alpha: 0.7),
      defaultColor.withValues(alpha: 0.4),
    ];
    final groupColors = bar.groupColors ?? defaultGroupColors;

    for (int g = 0; g < groupCount; g++) {
      final value = bar.allValues[g] * animationValue;
      final barHeight = (value / max) * totalHeight;
      final left =
          index * slotWidth + (slotWidth - barWidth) / 2 + g * singleBarWidth;
      final top = totalHeight - barHeight;
      final color = groupColors[g % groupColors.length];

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, singleBarWidth * 0.9, barHeight),
        Radius.circular(borderRadius),
      );
      canvas.drawRRect(rect, Paint()..color = color);
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

  void _drawLabel(Canvas canvas, Size size, String label, int index,
      double slotWidth, double totalHeight) {
    final textStyle =
        style.labelStyle ?? const TextStyle(color: Colors.grey, fontSize: 10);
    final textSpan = TextSpan(text: label, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    final x = index * slotWidth + (slotWidth - textPainter.width) / 2;
    textPainter.paint(canvas, Offset(x, totalHeight + 4));
  }

  double _calculateMax() {
    double max = 0;
    for (final bar in bars) {
      for (final v in bar.allValues) {
        if (v > max) max = v;
      }
    }
    return max;
  }

  @override
  bool shouldRepaint(covariant SnapBarChartPainter oldDelegate) => true;
}
