import 'package:flutter/material.dart';
import '../models/snap_pie_section.dart';
import '../models/snap_style.dart';
import '../models/snap_touch_data.dart';
import '../painters/snap_pie_chart_painter.dart';

/// A simple pie/donut chart widget.
///
/// ```dart
/// SnapPieChart(
///   sections: [
///     SnapPieSection(value: 40, label: 'A', color: Colors.blue),
///     SnapPieSection(value: 30, label: 'B', color: Colors.red),
///     SnapPieSection(value: 30, label: 'C', color: Colors.green),
///   ],
/// )
/// ```
class SnapPieChart extends StatefulWidget {
  /// Sections of the pie.
  final List<SnapPieSection> sections;

  /// Hole radius for donut chart (0.0 = full pie, 0.7 = thin donut).
  final double holeRadius;

  /// Starting angle in degrees (0 = right, 90 = bottom).
  final double startAngle;

  /// Space between sections in degrees.
  final double sectionSpace;

  /// Chart styling.
  final SnapChartStyle style;

  /// Touch callback.
  final ValueChanged<SnapTouchData>? onTouch;

  /// Whether to show labels on sections.
  final bool showLabels;

  /// Whether to show percentage values.
  final bool showPercentage;

  const SnapPieChart({
    super.key,
    required this.sections,
    this.holeRadius = 0.0,
    this.startAngle = -90,
    this.sectionSpace = 2,
    this.style = const SnapChartStyle(),
    this.onTouch,
    this.showLabels = true,
    this.showPercentage = false,
  });

  @override
  State<SnapPieChart> createState() => _SnapPieChartState();
}

class _SnapPieChartState extends State<SnapPieChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int? _touchedIndex;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.style.animationDuration,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.style.animationCurve,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(SnapPieChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sections != widget.sections) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultColors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.amber,
    ];

    return GestureDetector(
      onTapDown: (details) {
        _handleTouch(details.localPosition, context.size ?? Size.zero);
      },
      onTapUp: (_) {
        setState(() => _touchedIndex = null);
        widget.onTouch?.call(SnapTouchData.none);
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          return CustomPaint(
            size: Size.infinite,
            painter: SnapPieChartPainter(
              sections: widget.sections,
              animationValue: _animation.value,
              holeRadius: widget.holeRadius,
              startAngle: widget.startAngle,
              sectionSpace: widget.sectionSpace,
              defaultColors: defaultColors,
              touchedIndex: _touchedIndex,
              showLabels: widget.showLabels,
              showPercentage: widget.showPercentage,
              style: widget.style,
            ),
          );
        },
      ),
    );
  }

  void _handleTouch(Offset localPosition, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2;
    final diff = localPosition - center;
    final distance = diff.distance;

    if (distance > radius || distance < radius * widget.holeRadius) return;

    double angle = diff.direction * 180 / 3.14159265;
    angle = (angle - widget.startAngle + 360) % 360;

    final total = widget.sections.fold<double>(0, (sum, s) => sum + s.value);
    double cumulative = 0;

    for (int i = 0; i < widget.sections.length; i++) {
      final sweep = widget.sections[i].value / total * 360;
      if (angle >= cumulative && angle < cumulative + sweep) {
        setState(() => _touchedIndex = i);
        widget.onTouch?.call(SnapTouchData(
          index: i,
          sectionValue: widget.sections[i].value,
          isTouched: true,
        ));
        return;
      }
      cumulative += sweep;
    }
  }
}
