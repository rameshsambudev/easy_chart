/// EasyChart - A dead-simple Flutter charting library.
///
/// Beautiful charts with minimal code. Just pass your data and go.
///
/// ```dart
/// EasyLineChart(
///   spots: [EasySpot(0, 3), EasySpot(1, 1), EasySpot(2, 4)],
/// )
/// ```
library easy_chart;

// Models
export 'src/models/easy_spot.dart';
export 'src/models/easy_bar_data.dart';
export 'src/models/easy_pie_section.dart';
export 'src/models/easy_touch_data.dart';
export 'src/models/easy_style.dart';

// Charts
export 'src/charts/easy_line_chart.dart';
export 'src/charts/easy_bar_chart.dart';
export 'src/charts/easy_pie_chart.dart';
export 'src/charts/easy_scatter_chart.dart';
