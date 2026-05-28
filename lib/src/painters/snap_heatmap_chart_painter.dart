import 'package:flutter/material.dart';
import '../models/snap_heatmap_data.dart';
import '../models/snap_style.dart';

class SnapHeatmapChartPainter extends CustomPainter {
  final List<SnapHeatmapCell> cells;
  final int columns;
  final int rows;
  final double animationValue;
  final SnapHeatmapStyle heatmapStyle;
  final SnapChartStyle style;
  final int? touchedIndex;
  final double? minValue;
  final double? maxValue;

  SnapHeatmapChartPainter({
    required this.cells,
    required this.columns,
    required this.rows,
    required this.animationValue,
    required this.heatmapStyle,
    required this.style,
    this.touchedIndex,
    this.minValue,
    this.maxValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (cells.isEmpty) return;

    if (style.backgroundColor != null) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = style.backgroundColor!,
      );
    }

    final min = minValue ??
        cells.fold<double>(
            double.infinity, (m, c) => c.value < m ? c.value : m);
    final max = maxValue ??
        cells.fold<double>(
            double.negativeInfinity, (m, c) => c.value > m ? c.value : m);
    final range = max - min;
    if (range == 0) return;

    final cellWidth =
        (size.width - (columns - 1) * heatmapStyle.cellGap) / columns;
    final cellHeight = (size.height - (rows - 1) * heatmapStyle.cellGap) / rows;

    for (int i = 0; i < cells.length; i++) {
      final cell = cells[i];
      final t = ((cell.value - min) / range).clamp(0.0, 1.0) * animationValue;
      final color =
          Color.lerp(heatmapStyle.minColor, heatmapStyle.maxColor, t)!;
      final isTouched = touchedIndex == i;

      final x = cell.col * (cellWidth + heatmapStyle.cellGap);
      final y = cell.row * (cellHeight + heatmapStyle.cellGap);

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, cellWidth, cellHeight),
        Radius.circular(heatmapStyle.cellRadius),
      );

      canvas.drawRRect(rect, Paint()..color = color);

      if (isTouched) {
        canvas.drawRRect(
          rect,
          Paint()
            ..color = Colors.white.withValues(alpha: 0.4)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      }

      if (heatmapStyle.showLabels && cell.label != null) {
        final textStyle = style.labelStyle ??
            const TextStyle(color: Colors.white, fontSize: 9);
        final textSpan = TextSpan(text: cell.label, style: textStyle);
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        )..layout();
        textPainter.paint(
          canvas,
          Offset(
            x + (cellWidth - textPainter.width) / 2,
            y + (cellHeight - textPainter.height) / 2,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant SnapHeatmapChartPainter oldDelegate) => true;
}
