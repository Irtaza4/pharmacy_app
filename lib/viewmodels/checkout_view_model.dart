import 'package:flutter/foundation.dart';
import '../models/product.dart';
import 'shop_view_model.dart';

class CheckoutViewModel extends ChangeNotifier {
  CheckoutViewModel(this.shop);
  final ShopViewModel shop;
  String name = '', email = '', address = '', city = '', postal = '';
  bool express = false;
  int step = 0;
  DemoOrder? order;
  int get shipping => express ? 995 : shop.shipping;
  int get total => shop.subtotal + shipping;
  String? requiredField(String? value) =>
      value == null || value.trim().isEmpty ? 'Please fill this in' : null;
  String? validateEmail(String? value) =>
      RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value?.trim() ?? '')
      ? null
      : 'Enter a valid email address';
  void selectDelivery(bool value) {
    express = value;
    notifyListeners();
  }

  void review() {
    step = 1;
    notifyListeners();
  }

  void edit() {
    step = 0;
    notifyListeners();
  }

  DemoOrder submit() => order ??= shop.completeDemoOrder(name.trim(), shipping);
}
