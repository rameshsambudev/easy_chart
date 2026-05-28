/// OHLC (Open-High-Low-Close) bar data for stock charts.
///
/// Similar to candlestick but rendered as bars with ticks.
class SnapOHLC {
  final double date;
  final double open;
  final double high;
  final double low;
  final double close;
  final double? volume;

  const SnapOHLC({
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    this.volume,
  });

  bool get isBullish => close >= open;
}
