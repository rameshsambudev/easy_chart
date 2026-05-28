import 'dart:math';
import 'package:flutter/material.dart';
import 'package:snap_chart/snap_chart.dart';

void main() {
  runApp(const EasyChartExampleApp());
}

class EasyChartExampleApp extends StatelessWidget {
  const EasyChartExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyChart Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const ChartGallery(),
    );
  }
}

class ChartGallery extends StatefulWidget {
  const ChartGallery({super.key});

  @override
  State<ChartGallery> createState() => _ChartGalleryState();
}

class _ChartGalleryState extends State<ChartGallery> {
  String _touchInfo = 'Tap or drag on any chart';
  final _random = Random();

  // Line chart data
  List<EasySpot> _lineSpots = [
    const EasySpot(0, 3),
    const EasySpot(1, 1),
    const EasySpot(2, 4),
    const EasySpot(3, 1.5),
    const EasySpot(4, 5),
    const EasySpot(5, 2.5),
    const EasySpot(6, 4.5),
  ];

  // Bar chart data
  List<EasyBar> _bars = const [
    EasyBar(value: 10, label: 'Mon'),
    EasyBar(value: 15, label: 'Tue'),
    EasyBar(value: 8, label: 'Wed'),
    EasyBar(value: 12, label: 'Thu'),
    EasyBar(value: 18, label: 'Fri'),
    EasyBar(value: 6, label: 'Sat'),
    EasyBar(value: 9, label: 'Sun'),
  ];

  void _randomizeLineData() {
    setState(() {
      _lineSpots = List.generate(
        7,
        (i) => EasySpot(i.toDouble(), _random.nextDouble() * 6),
      );
    });
  }

  void _randomizeBarData() {
    setState(() {
      final labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      _bars = List.generate(
        7,
        (i) => EasyBar(value: _random.nextDouble() * 20 + 2, label: labels[i]),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EasyChart Gallery'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Touch info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _touchInfo,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 24),

            // Line Chart
            _buildSection(
              title: 'Line Chart',
              action: TextButton(
                onPressed: _randomizeLineData,
                child: const Text('Randomize'),
              ),
              child: SizedBox(
                height: 200,
                child: EasyLineChart(
                  spots: _lineSpots,
                  curved: true,
                  filled: true,
                  showDots: true,
                  lineWidth: 3,
                  fillOpacity: 0.15,
                  onTouch: (data) {
                    setState(() {
                      if (data.isTouched && data.spot != null) {
                        _touchInfo =
                            'Line: x=${data.spot!.x.toStringAsFixed(1)}, y=${data.spot!.y.toStringAsFixed(1)}';
                      }
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Multi-line Chart
            _buildSection(
              title: 'Multi-Line Chart',
              child: SizedBox(
                height: 200,
                child: EasyLineChart(
                  multiLines: [
                    const [
                      EasySpot(0, 2),
                      EasySpot(1, 4),
                      EasySpot(2, 3),
                      EasySpot(3, 5),
                      EasySpot(4, 4),
                    ],
                    const [
                      EasySpot(0, 1),
                      EasySpot(1, 2),
                      EasySpot(2, 4),
                      EasySpot(3, 3),
                      EasySpot(4, 6),
                    ],
                  ],
                  curved: true,
                  lineWidth: 2.5,
                  style: const EasyChartStyle(
                    showGrid: true,
                    gridColor: Color(0xFFEEEEEE),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Bar Chart
            _buildSection(
              title: 'Bar Chart',
              action: TextButton(
                onPressed: _randomizeBarData,
                child: const Text('Randomize'),
              ),
              child: SizedBox(
                height: 200,
                child: EasyBarChart(
                  bars: _bars,
                  borderRadius: 6,
                  onTouch: (data) {
                    setState(() {
                      if (data.isTouched) {
                        _touchInfo =
                            'Bar: index=${data.index}, value=${data.barValue?.toStringAsFixed(1)}';
                      }
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Grouped Bar Chart
            _buildSection(
              title: 'Grouped Bar Chart',
              child: SizedBox(
                height: 200,
                child: EasyBarChart(
                  bars: const [
                    EasyBar(
                      label: 'Q1',
                      groupValues: [12, 8, 15],
                      groupColors: [Colors.blue, Colors.orange, Colors.green],
                    ),
                    EasyBar(
                      label: 'Q2',
                      groupValues: [10, 14, 9],
                      groupColors: [Colors.blue, Colors.orange, Colors.green],
                    ),
                    EasyBar(
                      label: 'Q3',
                      groupValues: [16, 11, 13],
                      groupColors: [Colors.blue, Colors.orange, Colors.green],
                    ),
                    EasyBar(
                      label: 'Q4',
                      groupValues: [14, 17, 10],
                      groupColors: [Colors.blue, Colors.orange, Colors.green],
                    ),
                  ],
                  borderRadius: 4,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Pie Chart
            _buildSection(
              title: 'Pie Chart',
              child: SizedBox(
                height: 250,
                child: EasyPieChart(
                  sections: const [
                    EasyPieSection(
                      value: 35,
                      label: 'Flutter',
                      color: Colors.blue,
                    ),
                    EasyPieSection(
                      value: 25,
                      label: 'React',
                      color: Colors.cyan,
                    ),
                    EasyPieSection(
                      value: 20,
                      label: 'Native',
                      color: Colors.orange,
                    ),
                    EasyPieSection(
                      value: 15,
                      label: 'Kotlin',
                      color: Colors.purple,
                    ),
                    EasyPieSection(
                      value: 5,
                      label: 'Other',
                      color: Colors.grey,
                    ),
                  ],
                  showPercentage: true,
                  onTouch: (data) {
                    setState(() {
                      if (data.isTouched) {
                        _touchInfo =
                            'Pie: section=${data.index}, value=${data.sectionValue}';
                      }
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Donut Chart
            _buildSection(
              title: 'Donut Chart',
              child: SizedBox(
                height: 250,
                child: EasyPieChart(
                  sections: const [
                    EasyPieSection(
                      value: 40,
                      label: 'Dart',
                      color: Colors.teal,
                    ),
                    EasyPieSection(
                      value: 30,
                      label: 'Swift',
                      color: Colors.deepOrange,
                    ),
                    EasyPieSection(
                      value: 20,
                      label: 'Kotlin',
                      color: Colors.indigo,
                    ),
                    EasyPieSection(
                      value: 10,
                      label: 'Rust',
                      color: Colors.brown,
                    ),
                  ],
                  holeRadius: 0.55,
                  showLabels: true,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Scatter Chart
            _buildSection(
              title: 'Scatter Chart',
              child: SizedBox(
                height: 200,
                child: EasyScatterChart(
                  multiSeries: [
                    [
                      const EasySpot(1, 2),
                      const EasySpot(2, 4.5),
                      const EasySpot(3, 1.5),
                      const EasySpot(4, 5),
                      const EasySpot(5, 3),
                      const EasySpot(6, 4),
                    ],
                    [
                      const EasySpot(1.5, 3),
                      const EasySpot(2.5, 1),
                      const EasySpot(3.5, 4),
                      const EasySpot(4.5, 2),
                      const EasySpot(5.5, 5.5),
                    ],
                  ],
                  dotRadius: 8,
                  onTouch: (data) {
                    setState(() {
                      if (data.isTouched && data.spot != null) {
                        _touchInfo =
                            'Scatter: x=${data.spot!.x.toStringAsFixed(1)}, y=${data.spot!.y.toStringAsFixed(1)}';
                      }
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Minimal Style Line Chart
            _buildSection(
              title: 'Minimal Style (Sparkline)',
              child: SizedBox(
                height: 80,
                child: EasyLineChart(
                  spots: const [
                    EasySpot(0, 2),
                    EasySpot(1, 4),
                    EasySpot(2, 3),
                    EasySpot(3, 5),
                    EasySpot(4, 3.5),
                    EasySpot(5, 6),
                    EasySpot(6, 5),
                    EasySpot(7, 7),
                  ],
                  curved: true,
                  filled: true,
                  fillOpacity: 0.3,
                  lineWidth: 2,
                  style: EasyChartStyle.minimal,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
    Widget? action,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            ?action,
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}
