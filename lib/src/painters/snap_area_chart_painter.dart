import 'package:flutter/material.dart';
import '../models/snap_area_data.dart';
import '../models/snap_style.dart';

class SnapAreaChartPainter extends CustomPainter {
  final List<SnapAreaSeries> series;
  final double animationValue;
  final List<Color> defaultColors;
  final bool stacked;
  final bool curved;
  final SnapChartStyle style;
  final double? minX;
  final double? maxX;
  final double? minY;
  final double? maxY;

  SnapAreaChartPainter({
    required this.series,
    required this.animationValue,
    required this.defaultColors,
    required this.stacked,
    required this.curved,
    required this.style,
    this.minX,
    this.maxX,
    this.minY,
    this.maxY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (series.isEmpty) return;

    if (style.backgroundColor != null) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = style.backgroundColor!,
      );
    }

    if (style.showGrid) {
      _drawGrid(canvas, size);
    }

    final bounds = _calculateBounds();
    final xRange = bounds[2] - bounds[0];
    final yRange = bounds[3] - bounds[1];
    if (xRange == 0 || yRange == 0) return;

    // Draw areas from back to front
    for (int s = series.length - 1; s >= 0; s--) {
      final seriesData = series[s];
      final color = seriesData.color ?? defaultColors[s % defaultColors.length];
      final spots = seriesData.spots;
      if (spots.length < 2) continue;

      final points = spots.map((spot) {
        final x = (spot.x - bounds[0]) / xRange * size.width;
        final y = size.height -
            (spot.y - bounds[1]) / yRange * size.height * animationValue;
        return Offset(x, y);
      }).toList();

      // Fill
      final fillPath = Path()..moveTo(points.first.dx, size.height);
      if (curved && points.length > 2) {
        fillPath.lineTo(points.first.dx, points.first.dy);
        for (int i = 0; i < points.length - 1; i++) {
          final p0 = points[i];
          final p1 = points[i + 1];
          final midX = (p0.dx + p1.dx) / 2;
          fillPath.cubicTo(midX, p0.dy, midX, p1.dy, p1.dx, p1.dy);
        }
      } else {
        for (final p in points) {
          fillPath.lineTo(p.dx, p.dy);
        }
      }
      fillPath.lineTo(points.last.dx, size.height);
      fillPath.close();

      canvas.drawPath(
        fillPath,
        Paint()..color = color.withValues(alpha: seriesData.opacity),
      );

      // Stroke
      final strokePath = Path()..moveTo(points.first.dx, points.first.dy);
      if (curved && points.length > 2) {
        for (int i = 0; i < points.length - 1; i++) {
          final p0 = points[i];
          final p1 = points[i + 1];
          final midX = (p0.dx + p1.dx) / 2;
          strokePath.cubicTo(midX, p0.dy, midX, p1.dy, p1.dx, p1.dy);
        }
      } else {
        for (int i = 1; i < points.length; i++) {
          strokePath.lineTo(points[i].dx, points[i].dy);
        }
      }

      canvas.drawPath(
        strokePath,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round,
      );
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

  List<double> _calculateBounds() {
    double bMinX = minX ?? double.infinity;
    double bMaxX = maxX ?? double.negativeInfinity;
    double bMinY = minY ?? 0;
    double bMaxY = maxY ?? double.negativeInfinity;

    for (final s in series) {
      for (final spot in s.spots) {
        if (minX == null && spot.x < bMinX) bMinX = spot.x;
        if (maxX == null && spot.x > bMaxX) bMaxX = spot.x;
        if (maxY == null && spot.y > bMaxY) bMaxY = spot.y;
      }
    }
    return [bMinX, bMinY, bMaxX, bMaxY];
  }

  @override
  bool shouldRepaint(covariant SnapAreaChartPainter oldDelegate) => true;
}
