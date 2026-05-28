import 'package:flutter/material.dart';
import '../models/snap_spot.dart';
import '../models/snap_style.dart';
import '../models/snap_touch_data.dart';
import '../painters/snap_line_chart_painter.dart';

/// A simple line chart widget.
///
/// ```dart
/// SnapLineChart(
///   spots: [SnapSpot(0, 3), SnapSpot(1, 1), SnapSpot(2, 4)],
/// )
/// ```
class SnapLineChart extends StatefulWidget {
  /// Data points for the line.
  final List<SnapSpot> spots;

  /// Multiple lines support. If provided, [spots] is ignored.
  final List<List<SnapSpot>>? multiLines;

  /// Colors for each line. Defaults to theme colors.
  final List<Color>? lineColors;

  /// Line width in pixels.
  final double lineWidth;

  /// Whether to draw curved lines (spline) or straight segments.
  final bool curved;

  /// Whether to fill the area below the line.
  final bool filled;

  /// Fill opacity (0.0 to 1.0).
  final double fillOpacity;

  /// Whether to show dots at data points.
  final bool showDots;

  /// Dot radius.
  final double dotRadius;

  /// Chart styling.
  final SnapChartStyle style;

  /// Touch callback.
  final ValueChanged<SnapTouchData>? onTouch;

  /// Whether to show a tooltip on touch.
  final bool showTooltip;

  /// Min/max overrides. Null means auto-calculate from data.
  final double? minX;
  final double? maxX;
  final double? minY;
  final double? maxY;

  const SnapLineChart({
    super.key,
    this.spots = const [],
    this.multiLines,
    this.lineColors,
    this.lineWidth = 2.0,
    this.curved = true,
    this.filled = false,
    this.fillOpacity = 0.2,
    this.showDots = false,
    this.dotRadius = 4.0,
    this.style = const SnapChartStyle(),
    this.onTouch,
    this.showTooltip = true,
    this.minX,
    this.maxX,
    this.minY,
    this.maxY,
  });

  @override
  State<SnapLineChart> createState() => _SnapLineChartState();
}

class _SnapLineChartState extends State<SnapLineChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  List<List<SnapSpot>> _oldLines = [];
  List<List<SnapSpot>> _currentLines = [];
  int? _touchedIndex;
  Offset? _touchPosition;

  List<List<SnapSpot>> get _targetLines => widget.multiLines ?? [widget.spots];

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
    _currentLines = _targetLines;
    _oldLines = _targetLines;
    _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(SnapLineChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newLines = _targetLines;
    if (_listsChanged(_currentLines, newLines)) {
      _oldLines = _currentLines;
      _currentLines = newLines;
      _controller.forward(from: 0.0);
    }
  }

  bool _listsChanged(List<List<SnapSpot>> a, List<List<SnapSpot>> b) {
    if (a.length != b.length) return true;
    for (int i = 0; i < a.length; i++) {
      if (a[i].length != b[i].length) return true;
      for (int j = 0; j < a[i].length; j++) {
        if (a[i][j] != b[i][j]) return true;
      }
    }
    return false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTouch(Offset localPosition, Size size) {
    final lines = _currentLines;
    if (lines.isEmpty || lines.first.isEmpty) return;

    final allSpots = lines.first;
    final bounds = _calculateBounds(lines);
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
      if (dist < closestDist && dist < 40) {
        closestDist = dist;
        closestIdx = i;
      }
    }

    setState(() {
      _touchedIndex = closestIdx;
      _touchPosition = localPosition;
    });

    if (closestIdx >= 0) {
      widget.onTouch?.call(SnapTouchData(
        index: closestIdx,
        spot: allSpots[closestIdx],
        isTouched: true,
      ));
    }
  }

  List<double> _calculateBounds(List<List<SnapSpot>> lines) {
    double minX = widget.minX ?? double.infinity;
    double maxX = widget.maxX ?? double.negativeInfinity;
    double minY = widget.minY ?? double.infinity;
    double maxY = widget.maxY ?? double.negativeInfinity;

    for (final line in lines) {
      for (final spot in line) {
        if (widget.minX == null && spot.x < minX) minX = spot.x;
        if (widget.maxX == null && spot.x > maxX) maxX = spot.x;
        if (widget.minY == null && spot.y < minY) minY = spot.y;
        if (widget.maxY == null && spot.y > maxY) maxY = spot.y;
      }
    }
    return [minX, minY, maxX, maxY];
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
    final colors = widget.lineColors ?? defaultColors;

    return GestureDetector(
      onPanUpdate: (details) =>
          _handleTouch(details.localPosition, context.size ?? Size.zero),
      onPanEnd: (_) {
        setState(() {
          _touchedIndex = null;
          _touchPosition = null;
        });
        widget.onTouch?.call(SnapTouchData.none);
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          return CustomPaint(
            size: Size.infinite,
            painter: SnapLineChartPainter(
              oldLines: _oldLines,
              newLines: _currentLines,
              animationValue: _animation.value,
              colors: colors,
              lineWidth: widget.lineWidth,
              curved: widget.curved,
              filled: widget.filled,
              fillOpacity: widget.fillOpacity,
              showDots: widget.showDots,
              dotRadius: widget.dotRadius,
              style: widget.style,
              touchedIndex: _touchedIndex,
              touchPosition: _touchPosition,
              showTooltip: widget.showTooltip,
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
}
