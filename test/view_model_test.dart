import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_app/models/product.dart';
import 'package:pharmacy_app/repositories/shop_repository.dart';
import 'package:pharmacy_app/viewmodels/checkout_view_model.dart';
import 'package:pharmacy_app/viewmodels/product_view_model.dart';
import 'package:pharmacy_app/viewmodels/shop_view_model.dart';

void main() {
  test(
    'Cart merges matching packs, separates sizes and computes delivery in cents',
    () {
      final shop = ShopViewModel(ShopRepository());
      addTearDown(shop.dispose);
      shop.add(Product.relax);
      shop.add(Product.relax, quantity: 2);
      shop.add(Product.relax, pack: 60);
      expect(shop.items.length, 2);
      expect(shop.count, 4);
      expect(shop.subtotal, 12750);
      expect(shop.shipping, 0);
      shop.changeQuantity(shop.items.first, 0);
      expect(shop.subtotal, 5100);
      expect(shop.shipping, 495);
      shop.changeQuantity(shop.items.first, 0);
      expect(shop.total, 0);
    },
  );
  test('Checkout snapshots order, clears cart, and cannot submit twice', () {
    final shop = ShopViewModel(ShopRepository())..add(Product.sleep);
    final checkout = CheckoutViewModel(shop)..name = 'Sam';
    addTearDown(shop.dispose);
    addTearDown(checkout.dispose);
    checkout.selectDelivery(true);
    final order = checkout.submit();
    expect(order.total, 3545);
    expect(order.items.single.product, Product.sleep);
    expect(shop.items, isEmpty);
    expect(identical(checkout.submit(), order), isTrue);
    expect(checkout.validateEmail('invalid'), isNotNull);
    expect(checkout.validateEmail('sam@example.com'), isNull);
  });
  test('Product rejects invalid packs and quantities', () {
    final model = ProductViewModel(Product.focus);
    addTearDown(model.dispose);
    model.selectPack(17);
    model.changeQuantity(0);
    expect(model.pack, 30);
    expect(model.quantity, 1);
    model.selectPack(90);
    model.changeQuantity(3);
    expect(model.total, 25650);
  });
}
