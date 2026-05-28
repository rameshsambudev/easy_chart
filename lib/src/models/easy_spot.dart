import 'dart:ui';

/// A single data point with x and y coordinates.
///
/// ```dart
/// final point = EasySpot(2, 5.5);
/// ```
class EasySpot {
  final double x;
  final double y;

  const EasySpot(this.x, this.y);

  /// Create from a map like `{'x': 1, 'y': 2}`.
  factory EasySpot.fromMap(Map<String, num> map) {
    return EasySpot((map['x'] ?? 0).toDouble(), (map['y'] ?? 0).toDouble());
  }

  /// Linearly interpolate between two spots.
  static EasySpot lerp(EasySpot a, EasySpot b, double t) {
    return EasySpot(
      lerpDouble(a.x, b.x, t) ?? a.x,
      lerpDouble(a.y, b.y, t) ?? a.y,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EasySpot && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'EasySpot($x, $y)';
}
