import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/main.dart';

void main() {
  testWidgets('Splash screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const StockRadarApp());
    expect(find.text('Sa Gardaşım'), findsOneWidget);
  });
}
