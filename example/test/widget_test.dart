import 'package:flutter_test/flutter_test.dart';
import 'package:easy_chart_example/main.dart';

void main() {
  testWidgets('App renders chart gallery', (WidgetTester tester) async {
    await tester.pumpWidget(const SnapChartExampleApp());
    expect(find.text('SnapChart Gallery'), findsOneWidget);
  });
}
