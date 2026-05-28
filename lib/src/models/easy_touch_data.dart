import 'easy_spot.dart';

/// Touch event data returned in callbacks.
class EasyTouchData {
  /// Index of the touched element (-1 if none).
  final int index;

  /// The spot that was touched (for line/scatter charts).
  final EasySpot? spot;

  /// The bar value that was touched (for bar charts).
  final double? barValue;

  /// The section value that was touched (for pie charts).
  final double? sectionValue;

  /// Whether something is currently being touched.
  final bool isTouched;

  const EasyTouchData({
    this.index = -1,
    this.spot,
    this.barValue,
    this.sectionValue,
    this.isTouched = false,
  });

  /// Nothing is touched.
  static const none = EasyTouchData();
}
