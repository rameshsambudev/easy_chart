# SnapChart

A dead-simple Flutter charting library. Beautiful charts with minimal code.

Inspired by fl_chart but designed for developers who want charts without the boilerplate.

## Features

- **EasyLineChart** — Line/area charts with curves, fills, and multi-line support
- **EasyBarChart** — Vertical/horizontal bars with grouping
- **EasyPieChart** — Pie and donut charts
- **EasyScatterChart** — Scatter plots with multi-series

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

EasyLineChart(
  spots: [
    EasySpot(0, 3),
    EasySpot(1, 1),
    EasySpot(2, 4),
    EasySpot(3, 2),
  ],
)
```

### Line Chart with fill and dots

```dart
EasyLineChart(
  spots: myData,
  filled: true,
  showDots: true,
  curved: true,
  lineWidth: 3,
)
```

### Bar Chart

```dart
EasyBarChart(
  bars: [
    EasyBar(value: 10, label: 'Jan'),
    EasyBar(value: 15, label: 'Feb'),
    EasyBar(value: 8, label: 'Mar'),
    EasyBar(value: 12, label: 'Apr'),
  ],
)
```

### Pie Chart

```dart
EasyPieChart(
  sections: [
    EasyPieSection(value: 40, label: 'Flutter', color: Colors.blue),
    EasyPieSection(value: 30, label: 'React', color: Colors.cyan),
    EasyPieSection(value: 20, label: 'Native', color: Colors.green),
    EasyPieSection(value: 10, label: 'Other', color: Colors.grey),
  ],
)
```

### Donut Chart

```dart
EasyPieChart(
  sections: mySections,
  holeRadius: 0.6,
)
```

### Scatter Chart

```dart
EasyScatterChart(
  spots: [
    EasySpot(1, 2),
    EasySpot(3, 4),
    EasySpot(5, 1),
    EasySpot(7, 6),
  ],
)
```

### Touch Interactions

```dart
EasyLineChart(
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
EasyLineChart(
  spots: myData,
  style: EasyChartStyle(
    showGrid: true,
    gridColor: Colors.grey.shade200,
    showLabels: true,
    animationDuration: Duration(milliseconds: 500),
  ),
)
```

### Minimal Style (no grid, no labels)

```dart
EasyLineChart(
  spots: myData,
  style: EasyChartStyle.minimal,
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
