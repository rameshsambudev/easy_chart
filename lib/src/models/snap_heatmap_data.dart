import 'package:flutter/material.dart';

/// A single cell in a heatmap chart.
class SnapHeatmapCell {
  /// Column index.
  final int col;

  /// Row index.
  final int row;

  /// Value determining the color intensity.
  final double value;

  /// Optional label.
  final String? label;

  const SnapHeatmapCell({
    required this.col,
    required this.row,
    required this.value,
    this.label,
  });
}

/// Configuration for heatmap colors.
class SnapHeatmapStyle {
  /// Color for minimum value.
  final Color minColor;

  /// Color for maximum value.
  final Color maxColor;

  /// Cell border radius.
  final double cellRadius;

  /// Gap between cells.
  final double cellGap;

  /// Whether to show value labels in cells.
  final bool showLabels;

  const SnapHeatmapStyle({
    this.minColor = const Color(0xFFE8F5E9),
    this.maxColor = const Color(0xFF1B5E20),
    this.cellRadius = 4.0,
    this.cellGap = 2.0,
    this.showLabels = false,
  });
}
