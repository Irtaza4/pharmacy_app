import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_app/main.dart';
import 'package:pharmacy_app/models/product.dart';
import 'package:pharmacy_app/widgets/shop_widgets.dart';
import 'package:pharmacy_app/views/product_view.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    for (final font in ['Manrope', 'DMSerifDisplay']) {
      await (FontLoader(font)..addFont(
            rootBundle.load(
              font == 'Manrope'
                  ? 'assets/fonts/Manrope-Regular.ttf'
                  : 'assets/fonts/DMSerifDisplay.ttf',
            ),
          ))
          .load();
    }
  });
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

  Future<void> tap(WidgetTester tester, Finder finder) async {
    if (finder.evaluate().isEmpty) {
      await tester.scrollUntilVisible(
        finder,
        250,
        scrollable: find.byType(Scrollable).last,
      );
    }
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  testWidgets('Catalog search, favorites, and Hero navigation', (tester) async {
    await start(tester);
    await tap(tester, find.text('Products'));
    await tester.enterText(find.byType(TextField), 'sleep');
    await tester.pumpAndSettle();
    expect(find.text('Sleep'), findsOneWidget);
    expect(find.text('Relax'), findsNothing);
    await tap(tester, find.byTooltip('Save Sleep'));
    await tester.enterText(find.byType(TextField), '');
    await tap(tester, find.text('Saved'));
    expect(find.text('Sleep'), findsOneWidget);
    expect(find.text('Relax'), findsNothing);
    await tester.tap(find.byType(ProductObject));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 220));
    expect(find.byType(Hero), findsWidgets);
    expect(tester.takeException(), isNull);
    await tester.pumpAndSettle();
    expect(find.byType(ProductView), findsOneWidget);
    expect(find.text('Sleep 30\nDissolvable Wafers'), findsOneWidget);
    await tap(tester, find.byTooltip('Back'));
    expect(find.text('Good things.\nSmall packages.'), findsOneWidget);
  });

  testWidgets('Dragging a bottle into the bag adds exactly one item', (
    tester,
  ) async {
    await start(tester);
    final bottle = find.byWidgetPredicate(
      (w) => w is ProductObject && w.product == Product.relax,
    );
    final startPoint = tester.getCenter(bottle);
    final end = tester.getCenter(find.byType(BagTarget));
    final gesture = await tester.startGesture(startPoint);
    await gesture.moveBy(const Offset(0, -20));
    await tester.pump();
    await gesture.moveTo(end);
    await tester.pump(const Duration(milliseconds: 300));
    await gesture.up();
    await tester.pumpAndSettle();
    await tap(tester, find.byTooltip('Open bag'));
    expect(find.text('1 item'), findsOneWidget);
    expect(find.text('Relax'), findsOneWidget);
    expect(find.text('\$30.45'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Pack quantity, flight to bag, checkout validation, review and confirmation',
    (tester) async {
      await start(tester);
      await tester.tap(
        find.byWidgetPredicate(
          (w) => w is ProductObject && w.product == Product.relax,
        ),
      );
      await tester.pumpAndSettle();
      await tap(tester, find.text('60'));
      await tap(tester, find.byTooltip('Increase quantity'));
      expect(find.text('\$102.00'), findsOneWidget);
      await tap(tester, find.text('Add to bag'));
      await tester.pump(const Duration(milliseconds: 800));
      await tester.pumpAndSettle();
      await tap(tester, find.byTooltip('Open bag'));
      expect(find.text('2 items'), findsOneWidget);
      await tap(tester, find.text('Continue to checkout'));
      await tap(tester, find.text('Review your order'));
      expect(find.text('Please fill this in'), findsWidgets);
      final labels = {
        'Full name': 'Sam Example',
        'Email address': 'sam@example.com',
        'Street address': '12 Test Street',
        'City': 'Sample City',
        'Postal code': '12345',
      };
      for (final entry in labels.entries) {
        final field = find.widgetWithText(TextFormField, entry.key);
        await tester.ensureVisible(field);
        await tester.enterText(field, entry.value);
      }
      await tap(tester, find.text('A little sooner'));
      await tap(tester, find.text('Review your order'));
      expect(find.text('Looking good.'), findsOneWidget);
      await tap(tester, find.text('Edit details'));
      expect(find.text('Sam Example'), findsOneWidget);
      await tap(tester, find.text('Review your order'));
      await tap(tester, find.text('Place demo order'));
      expect(find.text('Good things.\nComing your way.'), findsOneWidget);
      expect(find.text('\$111.95'), findsOneWidget);
      await tap(tester, find.text('Keep feeling good'));
      await tap(tester, find.byTooltip('Open bag'));
      expect(find.text('Good things await.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Small phone supports catalog, cart editing and checkout', (
    tester,
  ) async {
    await start(tester, size: const Size(320, 568));
    await tap(tester, find.text('Products'));
    await tap(tester, find.byTooltip('Add Relax'));
    await tap(tester, find.byTooltip('Open bag'));
    await tap(tester, find.byTooltip('Increase quantity'));
    expect(find.text('2 items'), findsOneWidget);
    await tap(tester, find.text('Continue to checkout'));
    await tap(tester, find.text('Review your order'));
    expect(find.text('Please fill this in'), findsWidgets);
    await tap(tester, find.byTooltip('Back'));
    await tap(tester, find.byTooltip('Remove Relax'));
    expect(find.text('Good things await.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
