import 'package:flutter/material.dart';
import '../models/snap_gauge_data.dart';
import '../models/snap_style.dart';
import '../painters/snap_gauge_chart_painter.dart';

/// A gauge/meter chart for risk scores, portfolio health, etc.
///
/// ```dart
/// SnapGaugeChart(
///   data: SnapGaugeData(
///     value: 72,
///     min: 0,
///     max: 100,
///     label: 'Risk Score',
///     segments: [
///       SnapGaugeSegment(from: 0, to: 30, color: Colors.green),
///       SnapGaugeSegment(from: 30, to: 70, color: Colors.orange),
///       SnapGaugeSegment(from: 70, to: 100, color: Colors.red),
///     ],
///   ),
/// )
/// ```
class SnapGaugeChart extends StatefulWidget {
  /// Gauge data.
  final SnapGaugeData data;

  /// Chart styling.
  final SnapChartStyle style;

  const SnapGaugeChart({
    super.key,
    required this.data,
    this.style = const SnapChartStyle(),
  });

  @override
  State<SnapGaugeChart> createState() => _SnapGaugeChartState();
}

class _SnapGaugeChartState extends State<SnapGaugeChart>
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
  void didUpdateWidget(SnapGaugeChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data.value != widget.data.value) {
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return CustomPaint(
          size: Size.infinite,
          painter: SnapGaugeChartPainter(
            data: widget.data,
            animationValue: _animation.value,
            style: widget.style,
          ),
        );
      },
    );
  }
}
