import 'package:flutter_test/flutter_test.dart';
import 'package:analytics_dashboard/main.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const AnalyticsApp());
    expect(find.text('Analytics'), findsOneWidget);
  });
}
