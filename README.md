# SnapChart

A dead-simple Flutter charting library. Beautiful charts with minimal code.

Inspired by fl_chart but designed for developers who want charts without the boilerplate.

## Screenshots

<p float="left">
  <img src="https://raw.githubusercontent.com/rameshsambudev/easy_chart/main/screenshots/Screenshot_1779946858.png" width="200" />
  <img src="https://raw.githubusercontent.com/rameshsambudev/easy_chart/main/screenshots/Screenshot_1779946860.png" width="200" />
  <img src="https://raw.githubusercontent.com/rameshsambudev/easy_chart/main/screenshots/Screenshot_1779946862.png" width="200" />
  <img src="https://raw.githubusercontent.com/rameshsambudev/easy_chart/main/screenshots/Screenshot_1779946865.png" width="200" />
  <img src="https://raw.githubusercontent.com/rameshsambudev/easy_chart/main/screenshots/Screenshot_1779946867.png" width="200" />
</p>

## Features

- **SnapLineChart** — Line/area charts with curves, fills, and multi-line support
- **SnapBarChart** — Vertical/horizontal bars with grouping
- **SnapPieChart** — Pie and donut charts
- **SnapScatterChart** — Scatter plots with multi-series
- **SnapCandleChart** — Stock/crypto candlestick charts with volume
- **SnapWaterfallChart** — P&L breakdown, fund flow analysis
- **SnapGaugeChart** — Risk scores, portfolio health meters
- **SnapHeatmapChart** — Sector performance, contribution graphs
- **SnapAreaChart** — Portfolio allocation over time

All charts include:
- Animated transitions when data changes
- Touch interactions with callbacks
- Sensible defaults (just pass data and go)
- Full customization when you need it

## Getting Started

```yaml
dependencies:
  snap_chart: ^0.1.0
```

## Usage

### Line Chart

```dart
import 'package:snap_chart/snap_chart.dart';

SnapLineChart(
  spots: [
    SnapSpot(0, 3),
    SnapSpot(1, 1),
    SnapSpot(2, 4),
    SnapSpot(3, 2),
  ],
)
```

### Line Chart with fill and dots

```dart
SnapLineChart(
  spots: myData,
  filled: true,
  showDots: true,
  curved: true,
  lineWidth: 3,
)
```

### Bar Chart

```dart
SnapBarChart(
  bars: [
    SnapBar(value: 10, label: 'Jan'),
    SnapBar(value: 15, label: 'Feb'),
    SnapBar(value: 8, label: 'Mar'),
    SnapBar(value: 12, label: 'Apr'),
  ],
)
```

### Pie Chart

```dart
SnapPieChart(
  sections: [
    SnapPieSection(value: 40, label: 'Flutter', color: Colors.blue),
    SnapPieSection(value: 30, label: 'React', color: Colors.cyan),
    SnapPieSection(value: 20, label: 'Native', color: Colors.green),
    SnapPieSection(value: 10, label: 'Other', color: Colors.grey),
  ],
)
```

### Donut Chart

```dart
SnapPieChart(
  sections: mySections,
  holeRadius: 0.6,
)
```

### Scatter Chart

```dart
SnapScatterChart(
  spots: [
    SnapSpot(1, 2),
    SnapSpot(3, 4),
    SnapSpot(5, 1),
    SnapSpot(7, 6),
  ],
)
```

### Touch Interactions

```dart
SnapLineChart(
  spots: myData,
  onTouch: (touchData) {
    if (touchData.isTouched) {
      print('Touched point: ${touchData.spot}');
    }
  },
)
```

### Styling

```dart
SnapLineChart(
  spots: myData,
  style: SnapChartStyle(
    showGrid: true,
    gridColor: Colors.grey.shade200,
    showLabels: true,
    animationDuration: Duration(milliseconds: 500),
  ),
)
```

### Minimal Style (no grid, no labels)

```dart
SnapLineChart(
  spots: myData,
  style: SnapChartStyle.minimal,
)
```

### Candlestick Chart (Stocks/Crypto)

```dart
SnapCandleChart(
  candles: [
    SnapCandle(date: 0, open: 100, high: 110, low: 95, close: 105),
    SnapCandle(date: 1, open: 105, high: 115, low: 100, close: 98),
    SnapCandle(date: 2, open: 98, high: 108, low: 92, close: 106),
  ],
  candleStyle: SnapCandleStyle(showVolume: true),
)
```

### Waterfall Chart (P&L Breakdown)

```dart
SnapWaterfallChart(
  bars: [
    SnapWaterfallBar(value: 100, label: 'Revenue'),
    SnapWaterfallBar(value: -30, label: 'COGS'),
    SnapWaterfallBar(value: -20, label: 'OpEx'),
    SnapWaterfallBar(value: 50, label: 'Profit', isTotal: true),
  ],
)
```

### Gauge Chart (Risk Score / Portfolio Health)

```dart
SnapGaugeChart(
  data: SnapGaugeData(
    value: 72,
    min: 0,
    max: 100,
    label: 'Risk Score',
    segments: [
      SnapGaugeSegment(from: 0, to: 30, color: Colors.green),
      SnapGaugeSegment(from: 30, to: 70, color: Colors.orange),
      SnapGaugeSegment(from: 70, to: 100, color: Colors.red),
    ],
  ),
)
```

### Heatmap Chart (Sector Performance)

```dart
SnapHeatmapChart(
  cells: [
    SnapHeatmapCell(col: 0, row: 0, value: 5),
    SnapHeatmapCell(col: 1, row: 0, value: 10),
    SnapHeatmapCell(col: 2, row: 0, value: 3),
    // ...
  ],
  columns: 7,
  rows: 5,
  heatmapStyle: SnapHeatmapStyle(
    minColor: Colors.green.shade50,
    maxColor: Colors.green.shade900,
  ),
)
```

### Area Chart (Portfolio Allocation)

```dart
SnapAreaChart(
  series: [
    SnapAreaSeries(
      spots: [SnapSpot(0, 30), SnapSpot(1, 35), SnapSpot(2, 40)],
      label: 'Equity',
      color: Colors.blue,
    ),
    SnapAreaSeries(
      spots: [SnapSpot(0, 20), SnapSpot(1, 18), SnapSpot(2, 22)],
      label: 'Debt',
      color: Colors.green,
    ),
  ],
)
```

## Comparison with fl_chart

| Feature | fl_chart | snap_chart |
|---------|----------|------------|
| Line chart | ✅ | ✅ |
| Bar chart | ✅ | ✅ |
| Pie chart | ✅ | ✅ |
| Scatter chart | ✅ | ✅ |
| Candlestick chart | ✅ | ✅ |
| Waterfall chart | ❌ | ✅ |
| Gauge chart | ❌ | ✅ |
| Heatmap chart | ❌ | ✅ |
| Area chart | ✅ | ✅ |
| Minimum code for a chart | ~20 lines | ~3 lines |
| Touch interactions | Complex setup | Single callback |
| Animations | Manual | Automatic |
| Learning curve | Steep | Flat |

## License

MIT
