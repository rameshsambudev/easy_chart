# SnapChart

A dead-simple Flutter charting library. Beautiful charts with minimal code.

Inspired by fl_chart but designed for developers who want charts without the boilerplate.

## Features

- **SnapLineChart** — Line/area charts with curves, fills, and multi-line support
- **SnapBarChart** — Vertical/horizontal bars with grouping
- **SnapPieChart** — Pie and donut charts
- **SnapScatterChart** — Scatter plots with multi-series

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

## Comparison with fl_chart

| Feature | fl_chart | snap_chart |
|---------|----------|------------|
| Line chart | ✅ | ✅ |
| Bar chart | ✅ | ✅ |
| Pie chart | ✅ | ✅ |
| Scatter chart | ✅ | ✅ |
| Minimum code for a chart | ~20 lines | ~3 lines |
| Touch interactions | Complex setup | Single callback |
| Animations | Manual | Automatic |
| Learning curve | Steep | Flat |

## License

MIT
