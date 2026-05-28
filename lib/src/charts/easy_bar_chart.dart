import 'package:flutter/material.dart';
import '../models/easy_bar_data.dart';
import '../models/easy_style.dart';
import '../models/easy_touch_data.dart';
import '../painters/bar_chart_painter.dart';

/// A simple bar chart widget.
///
/// ```dart
/// EasyBarChart(
///   bars: [
///     EasyBar(value: 10, label: 'Jan'),
///     EasyBar(value: 15, label: 'Feb'),
///     EasyBar(value: 8, label: 'Mar'),
///   ],
/// )
/// ```
class EasyBarChart extends StatefulWidget {
  /// The bars to display.
  final List<EasyBar> bars;

  /// Default bar color. Individual bars can override.
  final Color? barColor;

  /// Bar corner radius.
  final double borderRadius;

  /// Space between bars (0.0 to 1.0, fraction of available space).
  final double spacing;

  /// Whether bars are horizontal.
  final bool horizontal;

  /// Chart styling.
  final EasyChartStyle style;

  /// Touch callback.
  final ValueChanged<EasyTouchData>? onTouch;

  /// Max value override. Null means auto-calculate.
  final double? maxValue;

  const EasyBarChart({
    super.key,
    required this.bars,
    this.barColor,
    this.borderRadius = 4.0,
    this.spacing = 0.3,
    this.horizontal = false,
    this.style = const EasyChartStyle(),
    this.onTouch,
    this.maxValue,
  });

  @override
  State<EasyBarChart> createState() => _EasyBarChartState();
}

class _EasyBarChartState extends State<EasyBarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  List<EasyBar> _oldBars = [];
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
  void didUpdateWidget(EasyBarChart oldWidget) {
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
      widget.onTouch?.call(
        EasyTouchData(
          index: index,
          barValue: widget.bars[index].value,
          isTouched: true,
        ),
      );
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
        widget.onTouch?.call(EasyTouchData.none);
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          return CustomPaint(
            size: Size.infinite,
            painter: EasyBarChartPainter(
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
