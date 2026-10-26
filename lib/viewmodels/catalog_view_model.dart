import 'package:flutter/foundation.dart';
import '../models/product.dart';

class CatalogViewModel extends ChangeNotifier {
  CatalogViewModel(this.products);
  final List<Product> products;
  String query = '', category = 'All';
  void search(String value) {
    query = value;
    notifyListeners();
  }

  void filter(String value) {
    category = value;
    notifyListeners();
  }

  List<Product> visible(Set<Product> favorites) => products
      .where(
        (p) =>
            (category == 'All' ||
                category == p.category ||
                category == 'Saved' && favorites.contains(p)) &&
            '${p.label} ${p.subtitle}'.toLowerCase().contains(
              query.toLowerCase(),
            ),
      )
      .toList();
}
