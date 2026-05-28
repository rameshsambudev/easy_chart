import 'package:flutter/material.dart';

/// A single candlestick data point for stock charts.
///
/// ```dart
/// SnapCandle(date: 0, open: 100, high: 110, low: 95, close: 105)
/// ```
class SnapCandle {
  /// X-axis position (typically date index or timestamp).
  final double date;

  /// Opening price.
  final double open;

  /// Highest price.
  final double high;

  /// Lowest price.
  final double low;

  /// Closing price.
  final double close;

  /// Trading volume (optional).
  final double? volume;

  const SnapCandle({
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    this.volume,
  });

  /// Whether the candle closed higher than it opened (bullish).
  bool get isBullish => close >= open;

  /// The body height (absolute difference between open and close).
  double get bodyHeight => (close - open).abs();

  /// The full range (high - low).
  double get range => high - low;
}

/// Configuration for candlestick chart appearance.
class SnapCandleStyle {
  /// Color for bullish (up) candles.
  final Color bullishColor;

  /// Color for bearish (down) candles.
  final Color bearishColor;

  /// Width of the candle body.
  final double bodyWidth;

  /// Width of the wick/shadow line.
  final double wickWidth;

  /// Whether to show volume bars below.
  final bool showVolume;

  /// Height fraction for volume section (0.0 to 0.4).
  final double volumeHeightFraction;

  const SnapCandleStyle({
    this.bullishColor = const Color(0xFF26A69A),
    this.bearishColor = const Color(0xFFEF5350),
    this.bodyWidth = 7.0,
    this.wickWidth = 1.5,
    this.showVolume = false,
    this.volumeHeightFraction = 0.2,
  });
}
