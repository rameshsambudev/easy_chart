/// SnapChart - A dead-simple Flutter charting library.
///
/// Beautiful charts with minimal code. Just pass your data and go.
///
/// ```dart
/// SnapLineChart(
///   spots: [SnapSpot(0, 3), SnapSpot(1, 1), SnapSpot(2, 4)],
/// )
/// ```
library snap_chart;

// Models
export 'src/models/snap_spot.dart';
export 'src/models/snap_bar_data.dart';
export 'src/models/snap_pie_section.dart';
export 'src/models/snap_touch_data.dart';
export 'src/models/snap_style.dart';

// Charts
export 'src/charts/snap_line_chart.dart';
export 'src/charts/snap_bar_chart.dart';
export 'src/charts/snap_pie_chart.dart';
export 'src/charts/snap_scatter_chart.dart';
