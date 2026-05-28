import 'package:flutter/material.dart';
import '../models/snap_area_data.dart';
import '../models/snap_style.dart';
import '../painters/snap_area_chart_painter.dart';

/// A stacked area chart for portfolio allocation over time, fund performance, etc.
///
/// ```dart
/// SnapAreaChart(
///   series: [
///     SnapAreaSeries(spots: [...], label: 'Equity', color: Colors.blue),
///     SnapAreaSeries(spots: [...], label: 'Debt', color: Colors.green),
///   ],
/// )
/// ```
class SnapAreaChart extends StatefulWidget {
  /// Area series data.
  final List<SnapAreaSeries> series;

  /// Whether areas are stacked.
  final bool stacked;

  /// Whether to use curved lines.
  final bool curved;

  /// Chart styling.
  final SnapChartStyle style;

  /// Min/max overrides.
  final double? minX;
  final double? maxX;
  final double? minY;
  final double? maxY;

  const SnapAreaChart({
    super.key,
    required this.series,
    this.stacked = false,
    this.curved = true,
    this.style = const SnapChartStyle(),
    this.minX,
    this.maxX,
    this.minY,
    this.maxY,
  });

  @override
  State<SnapAreaChart> createState() => _SnapAreaChartState();
}

class _SnapAreaChartState extends State<SnapAreaChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

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
  void didUpdateWidget(SnapAreaChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.series != widget.series) {
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
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.red,
    ];

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return CustomPaint(
          size: Size.infinite,
          painter: SnapAreaChartPainter(
            series: widget.series,
            animationValue: _animation.value,
            defaultColors: defaultColors,
            stacked: widget.stacked,
            curved: widget.curved,
            style: widget.style,
            minX: widget.minX,
            maxX: widget.maxX,
            minY: widget.minY,
            maxY: widget.maxY,
          ),
        );
      },
    );
  }
}
