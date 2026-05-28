import 'package:flutter/material.dart';

/// A section of a pie chart.
///
/// ```dart
/// EasyPieSection(value: 40, label: 'Flutter', color: Colors.blue)
/// ```
class EasyPieSection {
  /// The value of this section. Percentage is calculated automatically.
  final double value;

  /// Optional label for this section.
  final String? label;

  /// Section color. Auto-assigned if null.
  final Color? color;

  /// Radius of this section. Null means use chart default.
  final double? radius;

  /// Whether this section is "exploded" (pulled out).
  final bool exploded;

  const EasyPieSection({
    required this.value,
    this.label,
    this.color,
    this.radius,
    this.exploded = false,
  });
}
