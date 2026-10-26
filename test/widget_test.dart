import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_app/main.dart';

void main() {
  Future<void> start(
    WidgetTester tester, {
    Size size = const Size(390, 844),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
  }

  testWidgets('Product selection, pack pricing, quantities, and bag removal', (
    tester,
  ) async {
    await start(tester);
    expect(find.text('Powerful\nBoost'), findsOneWidget);
    await tester.tap(find.text('Products'));
    await tester.pumpAndSettle();
    expect(find.text('Relax 30\nDissolvable Wafers'), findsOneWidget);
    await tester.tap(find.text('60'));
    await tester.pumpAndSettle();
    expect(find.text('\$51.00'), findsOneWidget);
    await tester.tap(find.byTooltip('Increase quantity'));
    await tester.pump();
    expect(find.text('\$102.00'), findsOneWidget);
    await tester.tap(find.text('Buy Now'));
    await tester.pumpAndSettle();
    expect(find.text('Your bag'), findsOneWidget);
    expect(find.text('2 × \$51.00'), findsOneWidget);
    await tester.tap(find.byTooltip('Remove Relax'));
    await tester.pumpAndSettle();
    expect(find.textContaining('A little wellbeing'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Both products and home remain usable on a small phone', (
    tester,
  ) async {
    await start(tester, size: const Size(320, 568));
    await tester.tap(find.text('Products'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sleep'));
    await tester.pumpAndSettle();
    expect(find.text('Sleep 30\nDissolvable Wafers'), findsOneWidget);
    await tester.ensureVisible(find.text('Buy Now'));
    await tester.tap(find.text('Buy Now'));
    await tester.pumpAndSettle();
    expect(find.text('1 × \$25.50'), findsOneWidget);
    Navigator.of(tester.element(find.text('Your bag'))).pop();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Back to home'));
    await tester.pumpAndSettle();
    expect(find.text('Powerful\nBoost'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
