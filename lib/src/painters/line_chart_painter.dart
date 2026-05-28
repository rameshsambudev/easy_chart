import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../models/easy_spot.dart';
import '../models/easy_style.dart';

class EasyLineChartPainter extends CustomPainter {
  final List<List<EasySpot>> oldLines;
  final List<List<EasySpot>> newLines;
  final double animationValue;
  final List<Color> colors;
  final double lineWidth;
  final bool curved;
  final bool filled;
  final double fillOpacity;
  final bool showDots;
  final double dotRadius;
  final EasyChartStyle style;
  final int? touchedIndex;
  final Offset? touchPosition;
  final bool showTooltip;
  final double? minX;
  final double? maxX;
  final double? minY;
  final double? maxY;

  EasyLineChartPainter({
    required this.oldLines,
    required this.newLines,
    required this.animationValue,
    required this.colors,
    required this.lineWidth,
    required this.curved,
    required this.filled,
    required this.fillOpacity,
    required this.showDots,
    required this.dotRadius,
    required this.style,
    this.touchedIndex,
    this.touchPosition,
    this.showTooltip = true,
    this.minX,
    this.maxX,
    this.minY,
    this.maxY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (newLines.isEmpty) return;

    final bounds = _calculateBounds();
    final xRange = bounds[2] - bounds[0];
    final yRange = bounds[3] - bounds[1];
    if (xRange == 0 || yRange == 0) return;

    // Draw background
    if (style.backgroundColor != null) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = style.backgroundColor!,
      );
    }

    // Draw grid
    if (style.showGrid) {
      _drawGrid(canvas, size, bounds);
    }

    // Draw border
    if (style.showBorder) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()
          ..color = style.borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }

    // Draw each line
    for (int lineIdx = 0; lineIdx < newLines.length; lineIdx++) {
      final newSpots = newLines[lineIdx];
      final oldSpots = lineIdx < oldLines.length ? oldLines[lineIdx] : newSpots;
      final color = colors[lineIdx % colors.length];

      final interpolatedSpots = _interpolateSpots(oldSpots, newSpots);
      final points = _spotsToPoints(interpolatedSpots, size, bounds);

      if (points.length < 2) continue;

      // Draw fill
      if (filled) {
        _drawFill(canvas, size, points, color);
      }

      // Draw line
      _drawLine(canvas, points, color);

      // Draw dots
      if (showDots) {
        _drawDots(canvas, points, color);
      }
    }

    // Draw touch indicator
    if (touchedIndex != null && touchPosition != null && showTooltip) {
      _drawTouchIndicator(canvas, size);
    }
  }

  void _drawGrid(Canvas canvas, Size size, List<double> bounds) {
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

  void _drawFill(Canvas canvas, Size size, List<Offset> points, Color color) {
    final path = Path()..moveTo(points.first.dx, size.height);
    if (curved && points.length > 2) {
      path.lineTo(points.first.dx, points.first.dy);
      for (int i = 0; i < points.length - 1; i++) {
        final p0 = points[i];
        final p1 = points[i + 1];
        final midX = (p0.dx + p1.dx) / 2;
        path.cubicTo(midX, p0.dy, midX, p1.dy, p1.dx, p1.dy);
      }
    } else {
      for (final p in points) {
        path.lineTo(p.dx, p.dy);
      }
    }
    path.lineTo(points.last.dx, size.height);
    path.close();

    final gradient =
        ui.Gradient.linear(const Offset(0, 0), Offset(0, size.height), [
      color.withValues(alpha: fillOpacity),
      color.withValues(alpha: 0),
    ]);

    canvas.drawPath(path, Paint()..shader = gradient);
  }

  void _drawLine(Canvas canvas, List<Offset> points, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()..moveTo(points.first.dx, points.first.dy);

    if (curved && points.length > 2) {
      for (int i = 0; i < points.length - 1; i++) {
        final p0 = points[i];
        final p1 = points[i + 1];
        final midX = (p0.dx + p1.dx) / 2;
        path.cubicTo(midX, p0.dy, midX, p1.dy, p1.dx, p1.dy);
      }
    } else {
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }

    canvas.drawPath(path, paint);
  }

  void _drawDots(Canvas canvas, List<Offset> points, Color color) {
    final fillPaint = Paint()..color = Colors.white;
    final strokePaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < points.length; i++) {
      final radius = (touchedIndex == i) ? dotRadius * 1.5 : dotRadius;
      canvas.drawCircle(points[i], radius, fillPaint);
      canvas.drawCircle(points[i], radius, strokePaint);
    }
  }

  void _drawTouchIndicator(Canvas canvas, Size size) {
    if (touchPosition == null) return;
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.5)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(touchPosition!.dx, 0),
      Offset(touchPosition!.dx, size.height),
      paint,
    );
  }

  List<EasySpot> _interpolateSpots(
    List<EasySpot> oldSpots,
    List<EasySpot> newSpots,
  ) {
    if (animationValue >= 1.0) return newSpots;
    if (oldSpots.isEmpty) return newSpots;

    final maxLen =
        oldSpots.length > newSpots.length ? oldSpots.length : newSpots.length;
    final result = <EasySpot>[];

    for (int i = 0; i < maxLen; i++) {
      final oldIdx = i < oldSpots.length ? i : oldSpots.length - 1;
      final newIdx = i < newSpots.length ? i : newSpots.length - 1;
      result.add(
        EasySpot.lerp(oldSpots[oldIdx], newSpots[newIdx], animationValue),
      );
    }
    return result;
  }

  List<Offset> _spotsToPoints(
    List<EasySpot> spots,
    Size size,
    List<double> bounds,
  ) {
    final xRange = bounds[2] - bounds[0];
    final yRange = bounds[3] - bounds[1];
    return spots.map((spot) {
      final x = (spot.x - bounds[0]) / xRange * size.width;
      final y = size.height - (spot.y - bounds[1]) / yRange * size.height;
      return Offset(x, y);
    }).toList();
  }

  List<double> _calculateBounds() {
    double bMinX = minX ?? double.infinity;
    double bMaxX = maxX ?? double.negativeInfinity;
    double bMinY = minY ?? double.infinity;
    double bMaxY = maxY ?? double.negativeInfinity;

    for (final line in newLines) {
      for (final spot in line) {
        if (minX == null && spot.x < bMinX) bMinX = spot.x;
        if (maxX == null && spot.x > bMaxX) bMaxX = spot.x;
        if (minY == null && spot.y < bMinY) bMinY = spot.y;
        if (maxY == null && spot.y > bMaxY) bMaxY = spot.y;
      }
    }
    return [bMinX, bMinY, bMaxX, bMaxY];
  }

  @override
  bool shouldRepaint(covariant EasyLineChartPainter oldDelegate) => true;
}
