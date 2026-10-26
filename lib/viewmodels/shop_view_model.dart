import 'package:flutter/material.dart';
import '../models/product.dart';
import '../repositories/shop_repository.dart';

class ShopViewModel extends ChangeNotifier {
  ShopViewModel(this.repository);
  final ShopRepository repository;
  bool dragging = false;
  final Set<Product> favorites = {};
  List<Product> get products => repository.products;
  List<CartItem> get items => repository.cart;
  int get count => items.fold(0, (n, item) => n + item.quantity);
  int get subtotal => items.fold(0, (n, item) => n + item.total);
  int get shipping => subtotal == 0 || subtotal >= 6000 ? 0 : 495;
  int get total => subtotal + shipping;
  void setDragging(bool value) {
    if (dragging == value) return;
    dragging = value;
    notifyListeners();
  }

  void add(Product product, {int pack = 30, int quantity = 1}) {
    repository.add(product, pack, quantity);
    dragging = false;
    notifyListeners();
  }

  void changeQuantity(CartItem item, int quantity) {
    repository.setQuantity(item.id, quantity);
    notifyListeners();
  }

  void favorite(Product product) {
    favorites.contains(product)
        ? favorites.remove(product)
        : favorites.add(product);
    notifyListeners();
  }

  DemoOrder completeDemoOrder(String name, int deliveryCost) {
    final order = repository.placeDemoOrder(name: name, shipping: deliveryCost);
    notifyListeners();
    return order;
  }
}

class ShopScope extends InheritedNotifier<ShopViewModel> {
  const ShopScope({
    super.key,
    required ShopViewModel model,
    required super.child,
  }) : super(notifier: model);
  static ShopViewModel of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ShopScope>()!.notifier!;
}
