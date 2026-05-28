import 'package:flutter/material.dart';
import '../models/snap_spot.dart';
import '../models/snap_style.dart';

class SnapScatterChartPainter extends CustomPainter {
  final List<List<SnapSpot>> series;
  final double animationValue;
  final List<Color> colors;
  final double dotRadius;
  final SnapChartStyle style;
  final int? touchedIndex;
  final double? minX;
  final double? maxX;
  final double? minY;
  final double? maxY;

  SnapScatterChartPainter({
    required this.series,
    required this.animationValue,
    required this.colors,
    required this.dotRadius,
    required this.style,
    this.touchedIndex,
    this.minX,
    this.maxX,
    this.minY,
    this.maxY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (series.isEmpty) return;

    final bounds = _calculateBounds();
    final xRange = bounds[2] - bounds[0];
    final yRange = bounds[3] - bounds[1];
    if (xRange == 0 || yRange == 0) return;

    if (style.backgroundColor != null) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = style.backgroundColor!,
      );
    }

    if (style.showGrid) {
      _drawGrid(canvas, size);
    }

    if (style.showBorder) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()
          ..color = style.borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }

    int globalIdx = 0;
    for (int s = 0; s < series.length; s++) {
      final color = colors[s % colors.length];
      for (final spot in series[s]) {
        final x = (spot.x - bounds[0]) / xRange * size.width;
        final y = size.height - (spot.y - bounds[1]) / yRange * size.height;
        final isTouched = touchedIndex == globalIdx;
        final radius =
            (isTouched ? dotRadius * 1.5 : dotRadius) * animationValue;

        canvas.drawCircle(
          Offset(x, y),
          radius,
          Paint()..color = color.withValues(alpha: isTouched ? 1.0 : 0.8),
        );

        if (isTouched) {
          canvas.drawCircle(
            Offset(x, y),
            radius + 3,
            Paint()
              ..color = color.withValues(alpha: 0.3)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2,
          );
        }

        globalIdx++;
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
      final x = size.width * i / gridLines;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  List<double> _calculateBounds() {
    double bMinX = minX ?? double.infinity;
    double bMaxX = maxX ?? double.negativeInfinity;
    double bMinY = minY ?? double.infinity;
    double bMaxY = maxY ?? double.negativeInfinity;

    for (final s in series) {
      for (final spot in s) {
        if (minX == null && spot.x < bMinX) bMinX = spot.x;
        if (maxX == null && spot.x > bMaxX) bMaxX = spot.x;
        if (minY == null && spot.y < bMinY) bMinY = spot.y;
        if (maxY == null && spot.y > bMaxY) bMaxY = spot.y;
      }
    }
    return [bMinX, bMinY, bMaxX, bMaxY];
  }

  @override
  bool shouldRepaint(covariant SnapScatterChartPainter oldDelegate) => true;
}
