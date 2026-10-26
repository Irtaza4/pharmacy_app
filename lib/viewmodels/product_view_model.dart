import 'package:flutter/foundation.dart';
import '../models/product.dart';

class ProductViewModel extends ChangeNotifier {
  ProductViewModel(this.product);
  final Product product;
  int pack = 30, quantity = 1;
  int get total => product.priceFor(pack) * quantity;
  void selectPack(int size) {
    if (![30, 60, 90].contains(size)) return;
    pack = size;
    notifyListeners();
  }

  void changeQuantity(int value) {
    if (value < 1 || value > 99) return;
    quantity = value;
    notifyListeners();
  }
}
