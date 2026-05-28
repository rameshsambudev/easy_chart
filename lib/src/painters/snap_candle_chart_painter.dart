import 'package:flutter/material.dart';
import '../models/snap_candle_data.dart';
import '../models/snap_style.dart';

class SnapCandleChartPainter extends CustomPainter {
  final List<SnapCandle> candles;
  final double animationValue;
  final SnapCandleStyle candleStyle;
  final SnapChartStyle style;
  final int? touchedIndex;
  final double? minPrice;
  final double? maxPrice;

  SnapCandleChartPainter({
    required this.candles,
    required this.animationValue,
    required this.candleStyle,
    required this.style,
    this.touchedIndex,
    this.minPrice,
    this.maxPrice,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) return;

    final chartHeight = candleStyle.showVolume
        ? size.height * (1 - candleStyle.volumeHeightFraction)
        : size.height;
    final volumeHeight = size.height - chartHeight;

    if (style.backgroundColor != null) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = style.backgroundColor!,
      );
    }

    if (style.showGrid) {
      _drawGrid(canvas, Size(size.width, chartHeight));
    }

    final bounds = _calculateBounds();
    final priceRange = bounds[1] - bounds[0];
    if (priceRange == 0) return;

    final candleWidth = size.width / candles.length;
    final maxVol = candles.fold<double>(
        0, (m, c) => (c.volume ?? 0) > m ? (c.volume ?? 0) : m);

    for (int i = 0; i < candles.length; i++) {
      final candle = candles[i];
      final color = candle.isBullish
          ? candleStyle.bullishColor
          : candleStyle.bearishColor;
      final isTouched = touchedIndex == i;

      final centerX = i * candleWidth + candleWidth / 2;

      // Wick
      final highY =
          chartHeight - (candle.high - bounds[0]) / priceRange * chartHeight;
      final lowY =
          chartHeight - (candle.low - bounds[0]) / priceRange * chartHeight;
      final wickTop =
          highY * animationValue + chartHeight * (1 - animationValue);
      final wickBottom =
          lowY * animationValue + chartHeight * (1 - animationValue);

      canvas.drawLine(
        Offset(centerX, wickTop),
        Offset(centerX, wickBottom),
        Paint()
          ..color = color
          ..strokeWidth = candleStyle.wickWidth,
      );

      // Body
      final openY =
          chartHeight - (candle.open - bounds[0]) / priceRange * chartHeight;
      final closeY =
          chartHeight - (candle.close - bounds[0]) / priceRange * chartHeight;
      final bodyTop = (openY < closeY ? openY : closeY) * animationValue +
          chartHeight * (1 - animationValue);
      final bodyBottom = (openY > closeY ? openY : closeY) * animationValue +
          chartHeight * (1 - animationValue);
      final bodyH = (bodyBottom - bodyTop).clamp(1.0, double.infinity);

      final bodyWidth =
          isTouched ? candleStyle.bodyWidth * 1.3 : candleStyle.bodyWidth;

      final bodyRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          centerX - bodyWidth / 2,
          bodyTop,
          bodyWidth,
          bodyH,
        ),
        const Radius.circular(1),
      );

      if (candle.isBullish) {
        canvas.drawRRect(
          bodyRect,
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );
      } else {
        canvas.drawRRect(bodyRect, Paint()..color = color);
      }

      // Volume
      if (candleStyle.showVolume && candle.volume != null && maxVol > 0) {
        final volH =
            (candle.volume! / maxVol) * volumeHeight * 0.8 * animationValue;
        final volRect = Rect.fromLTWH(
          centerX - bodyWidth / 2,
          size.height - volH,
          bodyWidth,
          volH,
        );
        canvas.drawRect(
          volRect,
          Paint()..color = color.withValues(alpha: 0.4),
        );
      }

      // Touch highlight
      if (isTouched) {
        canvas.drawLine(
          Offset(centerX, 0),
          Offset(centerX, size.height),
          Paint()
            ..color = Colors.grey.withValues(alpha: 0.4)
            ..strokeWidth = 0.5,
        );
      }
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = style.gridColor
      ..strokeWidth = 0.5;

    const gridLines = 5;
    for (int i = 0; i <= gridLines; i++) {
      final y = size.height * i / gridLines;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  List<double> _calculateBounds() {
    double min = minPrice ?? double.infinity;
    double max = maxPrice ?? double.negativeInfinity;
    for (final c in candles) {
      if (minPrice == null && c.low < min) min = c.low;
      if (maxPrice == null && c.high > max) max = c.high;
    }
    final padding = (max - min) * 0.05;
    return [min - padding, max + padding];
  }

  @override
  bool shouldRepaint(covariant SnapCandleChartPainter oldDelegate) => true;
}
