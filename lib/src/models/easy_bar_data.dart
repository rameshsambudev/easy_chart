import 'package:flutter/material.dart';

/// A single bar (or group of bars) in a bar chart.
///
/// ```dart
/// EasyBar(value: 10, label: 'Jan')
/// ```
class EasyBar {
  /// The value (height) of this bar.
  final double value;

  /// Optional label shown below the bar.
  final String? label;

  /// Bar color. Defaults to theme primary if null.
  final Color? color;

  /// For grouped bars, provide multiple values.
  final List<double>? groupValues;

  /// Colors for grouped bars.
  final List<Color>? groupColors;

  const EasyBar({
    this.value = 0,
    this.label,
    this.color,
    this.groupValues,
    this.groupColors,
  });

  /// Whether this is a grouped bar.
  bool get isGrouped => groupValues != null && groupValues!.isNotEmpty;

  /// All values for this bar position (single or grouped).
  List<double> get allValues => isGrouped ? groupValues! : [value];
}
