import 'package:flutter/material.dart';

/// A single bar in a waterfall chart (useful for P&L breakdown).
class SnapWaterfallBar {
  /// The value (positive = gain, negative = loss).
  final double value;

  /// Label for this bar.
  final String? label;

  /// Whether this is a total/summary bar.
  final bool isTotal;

  /// Custom color. Auto-assigned based on value if null.
  final Color? color;

  const SnapWaterfallBar({
    required this.value,
    this.label,
    this.isTotal = false,
    this.color,
  });
}
