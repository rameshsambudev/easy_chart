import 'package:flutter/material.dart';
import '../models/snap_candle_data.dart';
import '../models/snap_style.dart';
import '../models/snap_touch_data.dart';
import '../painters/snap_candle_chart_painter.dart';

/// A candlestick chart for stock/crypto price data.
///
/// ```dart
/// SnapCandleChart(
///   candles: [
///     SnapCandle(date: 0, open: 100, high: 110, low: 95, close: 105),
///     SnapCandle(date: 1, open: 105, high: 115, low: 100, close: 98),
///   ],
/// )
/// ```
class SnapCandleChart extends StatefulWidget {
  /// Candlestick data.
  final List<SnapCandle> candles;

  /// Candle appearance.
  final SnapCandleStyle candleStyle;

  /// Chart styling.
  final SnapChartStyle style;

  /// Touch callback.
  final ValueChanged<SnapTouchData>? onTouch;

  /// Price range overrides.
  final double? minPrice;
  final double? maxPrice;

  const SnapCandleChart({
    super.key,
    required this.candles,
    this.candleStyle = const SnapCandleStyle(),
    this.style = const SnapChartStyle(),
    this.onTouch,
    this.minPrice,
    this.maxPrice,
  });

  @override
  State<SnapCandleChart> createState() => _SnapCandleChartState();
}

class _SnapCandleChartState extends State<SnapCandleChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int? _touchedIndex;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.style.animationDuration,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.style.animationCurve,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(SnapCandleChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.candles != widget.candles) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) =>
          _handleTouch(details.localPosition, context.size ?? Size.zero),
      onTapUp: (_) {
        setState(() => _touchedIndex = null);
        widget.onTouch?.call(SnapTouchData.none);
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          return CustomPaint(
            size: Size.infinite,
            painter: SnapCandleChartPainter(
              candles: widget.candles,
              animationValue: _animation.value,
              candleStyle: widget.candleStyle,
              style: widget.style,
              touchedIndex: _touchedIndex,
              minPrice: widget.minPrice,
              maxPrice: widget.maxPrice,
            ),
          );
        },
      ),
    );
  }

  void _handleTouch(Offset localPosition, Size size) {
    if (widget.candles.isEmpty) return;
    final candleWidth = size.width / widget.candles.length;
    final index = (localPosition.dx / candleWidth).floor();

    if (index >= 0 && index < widget.candles.length) {
      setState(() => _touchedIndex = index);
      final candle = widget.candles[index];
      widget.onTouch?.call(SnapTouchData(
        index: index,
        barValue: candle.close,
        isTouched: true,
      ));
    }
  }
}
