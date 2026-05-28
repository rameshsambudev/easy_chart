import 'package:flutter/material.dart';
import 'snap_spot.dart';

/// Data for a stacked area chart or portfolio area chart.
class SnapAreaSeries {
  /// Data points for this series.
  final List<SnapSpot> spots;

  /// Series label.
  final String? label;

  /// Fill color for this area.
  final Color? color;

  /// Fill opacity.
  final double opacity;

  const SnapAreaSeries({
    required this.spots,
    this.label,
    this.color,
    this.opacity = 0.6,
  });
}
