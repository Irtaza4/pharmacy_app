import '../models/product.dart';

/// Local demo data source. Replace with a store API without changing views.
class ShopRepository {
  List<Product> get products => Product.values;
  final Map<String, CartItem> _cart = {};
  int _orderSequence = 1000;
  List<CartItem> get cart => List.unmodifiable(_cart.values);

  void add(Product product, int pack, int quantity) {
    if (![30, 60, 90].contains(pack) || quantity < 1) return;
    final item = CartItem(product, pack, quantity);
    _cart.update(
      item.id,
      (old) => old.withQuantity(old.quantity + quantity),
      ifAbsent: () => item,
    );
  }

  void setQuantity(String id, int quantity) {
    if (quantity <= 0) {
      _cart.remove(id);
    } else if (_cart.containsKey(id)) {
      _cart[id] = _cart[id]!.withQuantity(quantity);
    }
  }

  DemoOrder placeDemoOrder({required String name, required int shipping}) {
    if (_cart.isEmpty) throw StateError('Your bag is empty.');
    final items = cart;
    final order = DemoOrder(
      number: 'XF-${++_orderSequence}',
      items: items,
      total: items.fold<int>(shipping, (n, item) => n + item.total),
      shipping: shipping,
      name: name,
    );
    _cart.clear();
    return order;
  }
}
