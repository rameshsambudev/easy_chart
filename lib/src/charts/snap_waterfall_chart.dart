import 'package:flutter/material.dart';
import '../models/snap_waterfall_data.dart';
import '../models/snap_style.dart';
import '../models/snap_touch_data.dart';
import '../painters/snap_waterfall_chart_painter.dart';

/// A waterfall chart for P&L breakdown, fund flow analysis.
///
/// ```dart
/// SnapWaterfallChart(
///   bars: [
///     SnapWaterfallBar(value: 100, label: 'Revenue'),
///     SnapWaterfallBar(value: -30, label: 'COGS'),
///     SnapWaterfallBar(value: -20, label: 'Expenses'),
///     SnapWaterfallBar(value: 50, label: 'Profit', isTotal: true),
///   ],
/// )
/// ```
class SnapWaterfallChart extends StatefulWidget {
  /// Waterfall bars.
  final List<SnapWaterfallBar> bars;

  /// Color for positive values.
  final Color positiveColor;

  /// Color for negative values.
  final Color negativeColor;

  /// Color for total bars.
  final Color totalColor;

  /// Bar corner radius.
  final double borderRadius;

  /// Spacing between bars.
  final double spacing;

  /// Chart styling.
  final SnapChartStyle style;

  /// Touch callback.
  final ValueChanged<SnapTouchData>? onTouch;

  const SnapWaterfallChart({
    super.key,
    required this.bars,
    this.positiveColor = const Color(0xFF26A69A),
    this.negativeColor = const Color(0xFFEF5350),
    this.totalColor = const Color(0xFF42A5F5),
    this.borderRadius = 3.0,
    this.spacing = 0.25,
    this.style = const SnapChartStyle(),
    this.onTouch,
  });

  @override
  State<SnapWaterfallChart> createState() => _SnapWaterfallChartState();
}

class _SnapWaterfallChartState extends State<SnapWaterfallChart>
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
  void didUpdateWidget(SnapWaterfallChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bars != widget.bars) {
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
    return GestureDetector(
      onTapDown: (details) =>
          _handleTouch(details.localPosition, context.size ?? Size.zero),
      onTapUp: (_) {
        setState(() => _touchedIndex = null);
        widget.onTouch?.call(SnapTouchData.none);
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          return CustomPaint(
            size: Size.infinite,
            painter: SnapWaterfallChartPainter(
              bars: widget.bars,
              animationValue: _animation.value,
              positiveColor: widget.positiveColor,
              negativeColor: widget.negativeColor,
              totalColor: widget.totalColor,
              borderRadius: widget.borderRadius,
              spacing: widget.spacing,
              style: widget.style,
              touchedIndex: _touchedIndex,
            ),
          );
        },
      ),
    );
  }

  void _handleTouch(Offset localPosition, Size size) {
    if (widget.bars.isEmpty) return;
    final slotWidth = size.width / widget.bars.length;
    final index = (localPosition.dx / slotWidth).floor();

    if (index >= 0 && index < widget.bars.length) {
      setState(() => _touchedIndex = index);
      widget.onTouch?.call(SnapTouchData(
        index: index,
        barValue: widget.bars[index].value,
        isTouched: true,
      ));
    }
  }
}
