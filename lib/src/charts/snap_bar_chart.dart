import 'package:flutter/material.dart';
import '../models/snap_bar_data.dart';
import '../models/snap_style.dart';
import '../models/snap_touch_data.dart';
import '../painters/snap_bar_chart_painter.dart';

/// A simple bar chart widget.
///
/// ```dart
/// SnapBarChart(
///   bars: [
///     SnapBar(value: 10, label: 'Jan'),
///     SnapBar(value: 15, label: 'Feb'),
///     SnapBar(value: 8, label: 'Mar'),
///   ],
/// )
/// ```
class SnapBarChart extends StatefulWidget {
  /// The bars to display.
  final List<SnapBar> bars;

  /// Default bar color. Individual bars can override.
  final Color? barColor;

  /// Bar corner radius.
  final double borderRadius;

  /// Space between bars (0.0 to 1.0, fraction of available space).
  final double spacing;

  /// Whether bars are horizontal.
  final bool horizontal;

  /// Chart styling.
  final SnapChartStyle style;

  /// Touch callback.
  final ValueChanged<SnapTouchData>? onTouch;

  /// Max value override. Null means auto-calculate.
  final double? maxValue;

  const SnapBarChart({
    super.key,
    required this.bars,
    this.barColor,
    this.borderRadius = 4.0,
    this.spacing = 0.3,
    this.horizontal = false,
    this.style = const SnapChartStyle(),
    this.onTouch,
    this.maxValue,
  });

  @override
  State<SnapBarChart> createState() => _SnapBarChartState();
}

class _SnapBarChartState extends State<SnapBarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  List<SnapBar> _oldBars = [];
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
    _oldBars = widget.bars;
    _controller.forward();
  }

  @override
  void didUpdateWidget(SnapBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bars != widget.bars) {
      _oldBars = oldWidget.bars;
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap(Offset localPosition, Size size) {
    final barCount = widget.bars.length;
    if (barCount == 0) return;

    final barWidth = size.width / barCount;
    final index = (localPosition.dx / barWidth).floor();

    if (index >= 0 && index < barCount) {
      setState(() => _touchedIndex = index);
      widget.onTouch?.call(SnapTouchData(
        index: index,
        barValue: widget.bars[index].value,
        isTouched: true,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = widget.barColor ?? theme.colorScheme.primary;

    return GestureDetector(
      onTapDown: (details) =>
          _handleTap(details.localPosition, context.size ?? Size.zero),
      onTapUp: (_) {
        setState(() => _touchedIndex = null);
        widget.onTouch?.call(SnapTouchData.none);
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          return CustomPaint(
            size: Size.infinite,
            painter: SnapBarChartPainter(
              bars: widget.bars,
              oldBars: _oldBars,
              animationValue: _animation.value,
              defaultColor: color,
              borderRadius: widget.borderRadius,
              spacing: widget.spacing,
              horizontal: widget.horizontal,
              style: widget.style,
              touchedIndex: _touchedIndex,
              maxValue: widget.maxValue,
            ),
          );
        },
      ),
    );
  }
}
