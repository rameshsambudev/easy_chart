import 'dart:ui';

/// A single data point with x and y coordinates.
///
/// ```dart
/// final point = SnapSpot(2, 5.5);
/// ```
class SnapSpot {
  final double x;
  final double y;

  const SnapSpot(this.x, this.y);

  /// Create from a map like `{'x': 1, 'y': 2}`.
  factory SnapSpot.fromMap(Map<String, num> map) {
    return SnapSpot(
      (map['x'] ?? 0).toDouble(),
      (map['y'] ?? 0).toDouble(),
    );
  }

  /// Linearly interpolate between two spots.
  static SnapSpot lerp(SnapSpot a, SnapSpot b, double t) {
    return SnapSpot(
      lerpDouble(a.x, b.x, t) ?? a.x,
      lerpDouble(a.y, b.y, t) ?? a.y,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SnapSpot && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'SnapSpot($x, $y)';
}
