import 'package:flutter/material.dart';
import '../models/easy_spot.dart';
import '../models/easy_style.dart';
import '../models/easy_touch_data.dart';
import '../painters/scatter_chart_painter.dart';

/// A simple scatter chart widget.
///
/// ```dart
/// EasyScatterChart(
///   spots: [EasySpot(1, 2), EasySpot(3, 4), EasySpot(5, 1)],
/// )
/// ```
class EasyScatterChart extends StatefulWidget {
  /// Data points to plot.
  final List<EasySpot> spots;

  /// Dot radius.
  final double dotRadius;

  /// Dot color. Defaults to theme primary.
  final Color? dotColor;

  /// Multiple series support.
  final List<List<EasySpot>>? multiSeries;

  /// Colors for each series.
  final List<Color>? seriesColors;

  /// Chart styling.
  final EasyChartStyle style;

  /// Touch callback.
  final ValueChanged<EasyTouchData>? onTouch;

  /// Min/max overrides.
  final double? minX;
  final double? maxX;
  final double? minY;
  final double? maxY;

  const EasyScatterChart({
    super.key,
    this.spots = const [],
    this.dotRadius = 6.0,
    this.dotColor,
    this.multiSeries,
    this.seriesColors,
    this.style = const EasyChartStyle(),
    this.onTouch,
    this.minX,
    this.maxX,
    this.minY,
    this.maxY,
  });

  @override
  State<EasyScatterChart> createState() => _EasyScatterChartState();
}

class _EasyScatterChartState extends State<EasyScatterChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int? _touchedIndex;

  List<List<EasySpot>> get _allSeries => widget.multiSeries ?? [widget.spots];

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
  void didUpdateWidget(EasyScatterChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultColors = [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
      theme.colorScheme.tertiary,
      Colors.orange,
      Colors.purple,
    ];
    final colors = widget.seriesColors ?? defaultColors;

    return GestureDetector(
      onTapDown: (details) =>
          _handleTouch(details.localPosition, context.size ?? Size.zero),
      onTapUp: (_) {
        setState(() => _touchedIndex = null);
        widget.onTouch?.call(EasyTouchData.none);
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          return CustomPaint(
            size: Size.infinite,
            painter: EasyScatterChartPainter(
              series: _allSeries,
              animationValue: _animation.value,
              colors: colors,
              dotRadius: widget.dotRadius,
              style: widget.style,
              touchedIndex: _touchedIndex,
              minX: widget.minX,
              maxX: widget.maxX,
              minY: widget.minY,
              maxY: widget.maxY,
            ),
          );
        },
      ),
    );
  }

  void _handleTouch(Offset localPosition, Size size) {
    final allSpots = _allSeries.expand((s) => s).toList();
    if (allSpots.isEmpty) return;

    final bounds = _calculateBounds();
    final xRange = bounds[2] - bounds[0];
    final yRange = bounds[3] - bounds[1];
    if (xRange == 0 || yRange == 0) return;

    double closestDist = double.infinity;
    int closestIdx = -1;

    for (int i = 0; i < allSpots.length; i++) {
      final spot = allSpots[i];
      final px = (spot.x - bounds[0]) / xRange * size.width;
      final py = size.height - (spot.y - bounds[1]) / yRange * size.height;
      final dist = (Offset(px, py) - localPosition).distance;
      if (dist < closestDist && dist < 30) {
        closestDist = dist;
        closestIdx = i;
      }
    }

    if (closestIdx >= 0) {
      setState(() => _touchedIndex = closestIdx);
      widget.onTouch?.call(
        EasyTouchData(
          index: closestIdx,
          spot: allSpots[closestIdx],
          isTouched: true,
        ),
      );
    }
  }

  List<double> _calculateBounds() {
    double minX = widget.minX ?? double.infinity;
    double maxX = widget.maxX ?? double.negativeInfinity;
    double minY = widget.minY ?? double.infinity;
    double maxY = widget.maxY ?? double.negativeInfinity;

    for (final series in _allSeries) {
      for (final spot in series) {
        if (widget.minX == null && spot.x < minX) minX = spot.x;
        if (widget.maxX == null && spot.x > maxX) maxX = spot.x;
        if (widget.minY == null && spot.y < minY) minY = spot.y;
        if (widget.maxY == null && spot.y > maxY) maxY = spot.y;
      }
    }
    return [minX, minY, maxX, maxY];
  }
}
