import 'package:flutter/material.dart';
import '../models/snap_heatmap_data.dart';
import '../models/snap_style.dart';
import '../models/snap_touch_data.dart';
import '../painters/snap_heatmap_chart_painter.dart';

/// A heatmap chart for contribution graphs, sector performance, etc.
///
/// ```dart
/// SnapHeatmapChart(
///   cells: [
///     SnapHeatmapCell(col: 0, row: 0, value: 5),
///     SnapHeatmapCell(col: 1, row: 0, value: 10),
///   ],
///   columns: 7,
///   rows: 5,
/// )
/// ```
class SnapHeatmapChart extends StatefulWidget {
  /// Heatmap cells.
  final List<SnapHeatmapCell> cells;

  /// Number of columns.
  final int columns;

  /// Number of rows.
  final int rows;

  /// Heatmap appearance.
  final SnapHeatmapStyle heatmapStyle;

  /// Chart styling.
  final SnapChartStyle style;

  /// Touch callback.
  final ValueChanged<SnapTouchData>? onTouch;

  /// Value range overrides.
  final double? minValue;
  final double? maxValue;

  const SnapHeatmapChart({
    super.key,
    required this.cells,
    required this.columns,
    required this.rows,
    this.heatmapStyle = const SnapHeatmapStyle(),
    this.style = const SnapChartStyle(showGrid: false),
    this.onTouch,
    this.minValue,
    this.maxValue,
  });

  @override
  State<SnapHeatmapChart> createState() => _SnapHeatmapChartState();
}

class _SnapHeatmapChartState extends State<SnapHeatmapChart>
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
  void didUpdateWidget(SnapHeatmapChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cells != widget.cells) {
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
            painter: SnapHeatmapChartPainter(
              cells: widget.cells,
              columns: widget.columns,
              rows: widget.rows,
              animationValue: _animation.value,
              heatmapStyle: widget.heatmapStyle,
              style: widget.style,
              touchedIndex: _touchedIndex,
              minValue: widget.minValue,
              maxValue: widget.maxValue,
            ),
          );
        },
      ),
    );
  }

  void _handleTouch(Offset localPosition, Size size) {
    final cellWidth =
        (size.width - (widget.columns - 1) * widget.heatmapStyle.cellGap) /
            widget.columns;
    final cellHeight =
        (size.height - (widget.rows - 1) * widget.heatmapStyle.cellGap) /
            widget.rows;

    final col =
        (localPosition.dx / (cellWidth + widget.heatmapStyle.cellGap)).floor();
    final row =
        (localPosition.dy / (cellHeight + widget.heatmapStyle.cellGap)).floor();

    for (int i = 0; i < widget.cells.length; i++) {
      if (widget.cells[i].col == col && widget.cells[i].row == row) {
        setState(() => _touchedIndex = i);
        widget.onTouch?.call(SnapTouchData(
          index: i,
          barValue: widget.cells[i].value,
          isTouched: true,
        ));
        return;
      }
    }
  }
}
