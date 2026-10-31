import 'package:flutter_test/flutter_test.dart';
import 'package:app/app/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const NavsanjiviniApp());
    await tester.pumpAndSettle();

    // Verify WelcomeScreen loads
    expect(find.text('Navsanjivini'), findsOneWidget);
  });
}
