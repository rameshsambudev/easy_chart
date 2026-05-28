import 'package:flutter/material.dart';

/// Data for a gauge/meter chart (useful for portfolio health, risk meters).
class SnapGaugeData {
  /// Current value.
  final double value;

  /// Minimum value.
  final double min;

  /// Maximum value.
  final double max;

  /// Label shown in center.
  final String? label;

  /// Segments with colors for different ranges.
  final List<SnapGaugeSegment> segments;

  /// Needle color.
  final Color needleColor;

  /// Whether to show the value text.
  final bool showValue;

  const SnapGaugeData({
    required this.value,
    this.min = 0,
    this.max = 100,
    this.label,
    this.segments = const [],
    this.needleColor = const Color(0xFF333333),
    this.showValue = true,
  });
}

/// A colored segment of the gauge arc.
class SnapGaugeSegment {
  final double from;
  final double to;
  final Color color;
  final String? label;

  const SnapGaugeSegment({
    required this.from,
    required this.to,
    required this.color,
    this.label,
  });
}
