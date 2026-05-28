import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/snap_pie_section.dart';
import '../models/snap_style.dart';

class SnapPieChartPainter extends CustomPainter {
  final List<SnapPieSection> sections;
  final double animationValue;
  final double holeRadius;
  final double startAngle;
  final double sectionSpace;
  final List<Color> defaultColors;
  final int? touchedIndex;
  final bool showLabels;
  final bool showPercentage;
  final SnapChartStyle style;

  SnapPieChartPainter({
    required this.sections,
    required this.animationValue,
    required this.holeRadius,
    required this.startAngle,
    required this.sectionSpace,
    required this.defaultColors,
    this.touchedIndex,
    required this.showLabels,
    required this.showPercentage,
    required this.style,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (sections.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2 * 0.85;
    final total = sections.fold<double>(0, (sum, s) => sum + s.value);
    if (total == 0) return;

    double currentAngle = startAngle * math.pi / 180;
    final spaceRad = sectionSpace * math.pi / 180;

    for (int i = 0; i < sections.length; i++) {
      final section = sections[i];
      final sweepAngle = (section.value / total) * 2 * math.pi * animationValue;
      final color = section.color ?? defaultColors[i % defaultColors.length];
      final sectionRadius = section.radius ?? radius;
      final isTouched = touchedIndex == i;
      final actualRadius = isTouched ? sectionRadius * 1.05 : sectionRadius;

      Offset explodeOffset = Offset.zero;
      if (section.exploded || isTouched) {
        final midAngle = currentAngle + sweepAngle / 2;
        explodeOffset = Offset(
          math.cos(midAngle) * 8,
          math.sin(midAngle) * 8,
        );
      }

      final sectionCenter = center + explodeOffset;

      final path = Path();
      if (holeRadius > 0) {
        final innerRadius = actualRadius * holeRadius;
        path.arcTo(
          Rect.fromCircle(center: sectionCenter, radius: actualRadius),
          currentAngle + spaceRad / 2,
          sweepAngle - spaceRad,
          false,
        );
        path.arcTo(
          Rect.fromCircle(center: sectionCenter, radius: innerRadius),
          currentAngle + sweepAngle - spaceRad / 2,
          -(sweepAngle - spaceRad),
          false,
        );
        path.close();
      } else {
        path.moveTo(sectionCenter.dx, sectionCenter.dy);
        path.arcTo(
          Rect.fromCircle(center: sectionCenter, radius: actualRadius),
          currentAngle + spaceRad / 2,
          sweepAngle - spaceRad,
          false,
        );
        path.close();
      }

      canvas.drawPath(path, Paint()..color = color);

      if (showLabels && animationValue > 0.8) {
        _drawLabel(canvas, sectionCenter, actualRadius, currentAngle,
            sweepAngle, section, total);
      }

      currentAngle += sweepAngle;
    }
  }

  void _drawLabel(
      Canvas canvas,
      Offset center,
      double radius,
      double startAngle,
      double sweepAngle,
      SnapPieSection section,
      double total) {
    final midAngle = startAngle + sweepAngle / 2;
    final labelRadius = radius * 0.7;
    final labelPos = Offset(
      center.dx + math.cos(midAngle) * labelRadius,
      center.dy + math.sin(midAngle) * labelRadius,
    );

    String text = '';
    if (section.label != null) {
      text = section.label!;
    }
    if (showPercentage) {
      final pct = (section.value / total * 100).toStringAsFixed(0);
      text = text.isEmpty ? '$pct%' : '$text\n$pct%';
    }

    if (text.isEmpty) return;

    final textStyle = style.labelStyle ??
        const TextStyle(
            color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold);
    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(
        labelPos.dx - textPainter.width / 2,
        labelPos.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant SnapPieChartPainter oldDelegate) => true;
}
