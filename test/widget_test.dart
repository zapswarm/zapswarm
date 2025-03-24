import 'package:flutter_test/flutter_test.dart';
import 'package:zapswarm/main.dart';

void main() {
  testWidgets('ZapSwarm smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ZapSwarmApp());
    await tester.pump(const Duration(seconds: 2)); // Wait for splash screen
    expect(find.text('Zap Now'), findsOneWidget);
  });
}