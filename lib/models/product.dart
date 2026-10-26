import 'package:flutter/material.dart';

enum Product {
  relax(
    'Relax',
    'A moment of calm',
    'Unwind',
    Color(0xFFF4CE45),
    2550,
    'Make a little space for yourself. A pocket-sized companion to your wind-down ritual.',
  ),
  sleep(
    'Sleep',
    'Find your evening rhythm',
    'Unwind',
    Color(0xFFA62E4C),
    2550,
    'Dim the lights, put the day down, and make your evening ritual a little more intentional.',
  ),
  focus(
    'Focus',
    'Make room for clarity',
    'Everyday',
    Color(0xFFA8B998),
    2850,
    'A small addition to your desk-side routine. Make space for the things that matter to you.',
  ),
  energy(
    'Energy',
    'A brighter kind of day',
    'Everyday',
    Color(0xFFEAA16F),
    2750,
    'Meet your morning with a fresh perspective. Your colorful companion for everyday rituals.',
  ),
  balance(
    'Balance',
    'Come back to yourself',
    'Everyday',
    Color(0xFFB6A4CF),
    2950,
    'Slow down and find your own rhythm. A simple ritual for a little more me-time.',
  ),
  glow(
    'Glow',
    'Your daily bright spot',
    'Everyday',
    Color(0xFFE3AAB7),
    2850,
    'Bring a little joy to the everyday. A gentle reminder to make time for yourself.',
  );

  const Product(
    this.label,
    this.subtitle,
    this.category,
    this.color,
    this.basePrice,
    this.description,
  );
  final String label, subtitle, category, description;
  final Color color;
  final int basePrice;
  bool get isDark => this == sleep;
  int priceFor(int pack) => basePrice * pack ~/ 30;
}

String money(int cents) => '\$${(cents / 100).toStringAsFixed(2)}';

@immutable
class CartItem {
  const CartItem(this.product, this.pack, this.quantity);
  final Product product;
  final int pack, quantity;
  String get id => '${product.name}-$pack';
  int get total => product.priceFor(pack) * quantity;
  CartItem withQuantity(int value) => CartItem(product, pack, value);
}

@immutable
class DemoOrder {
  const DemoOrder({
    required this.number,
    required this.items,
    required this.total,
    required this.shipping,
    required this.name,
  });
  final String number, name;
  final List<CartItem> items;
  final int total, shipping;
}
