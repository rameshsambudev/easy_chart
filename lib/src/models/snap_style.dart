import 'package:flutter/material.dart';

/// Styling configuration for charts. All fields are optional with sensible defaults.
class SnapChartStyle {
  /// Background color of the chart area.
  final Color? backgroundColor;

  /// Whether to show grid lines.
  final bool showGrid;

  /// Grid line color.
  final Color gridColor;

  /// Whether to show axis labels.
  final bool showLabels;

  /// Text style for labels.
  final TextStyle? labelStyle;

  /// Whether to show a border around the chart.
  final bool showBorder;

  /// Border color.
  final Color borderColor;

  /// Animation duration when data changes.
  final Duration animationDuration;

  /// Animation curve.
  final Curve animationCurve;

  const SnapChartStyle({
    this.backgroundColor,
    this.showGrid = true,
    this.gridColor = const Color(0xFFE0E0E0),
    this.showLabels = true,
    this.labelStyle,
    this.showBorder = false,
    this.borderColor = const Color(0xFFBDBDBD),
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
  });

  /// No grid, no labels, no border. Just the chart.
  static const minimal = SnapChartStyle(
    showGrid: false,
    showLabels: false,
    showBorder: false,
  );
}
