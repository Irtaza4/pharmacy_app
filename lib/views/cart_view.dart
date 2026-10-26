import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../viewmodels/shop_view_model.dart';
import '../widgets/product_art.dart';
import '../widgets/shop_widgets.dart';
import 'catalog_view.dart';
import 'checkout_view.dart';
import 'product_view.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});
  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ShopHeader(showBag: false),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Reveal(
                        child: Text(
                          'A LITTLE CARE, COLLECTED.',
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 1.7,
                            fontWeight: FontWeight.w700,
                            color: muted,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Expanded(
                            child: Text(
                              'Your bag',
                              style: TextStyle(
                                fontSize: 41,
                                letterSpacing: -2,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            '${shop.count} ${shop.count == 1 ? 'item' : 'items'}',
                            style: const TextStyle(fontSize: 13, color: muted),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: shop.items.isEmpty
                            ? _EmptyBag(key: const ValueKey('empty'))
                            : Column(
                                key: const ValueKey('items'),
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(17),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE7EDDE),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.local_shipping_outlined,
                                              size: 19,
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                shop.subtotal >= 6000
                                                    ? 'Your delivery is on us!'
                                                    : '${money(6000 - shop.subtotal)} away from free delivery',
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        TweenAnimationBuilder<double>(
                                          duration: const Duration(
                                            milliseconds: 400,
                                          ),
                                          tween: Tween(
                                            end: (shop.subtotal / 6000).clamp(
                                              0,
                                              1,
                                            ),
                                          ),
                                          builder: (_, value, _) => ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                            child: LinearProgressIndicator(
                                              value: value,
                                              minHeight: 4,
                                              color: ink,
                                              backgroundColor: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  ...shop.items.map(
                                    (item) => _CartCard(
                                      key: ValueKey(item.id),
                                      item: item,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Divider(color: Color(0xFFE0E4D9)),
                                  const SizedBox(height: 12),
                                  SummaryRow('Subtotal', money(shop.subtotal)),
                                  SummaryRow(
                                    'Standard delivery',
                                    shop.shipping == 0
                                        ? 'On us'
                                        : money(shop.shipping),
                                  ),
                                  const SizedBox(height: 8),
                                  SummaryRow(
                                    'Total',
                                    money(shop.total),
                                    bold: true,
                                  ),
                                  const SizedBox(height: 22),
                                  ActionButton(
                                    'Continue to checkout',
                                    onTap: () =>
                                        navigate(context, const CheckoutView()),
                                  ),
                                  const SizedBox(height: 12),
                                  TextButton(
                                    onPressed: () =>
                                        navigate(context, const CatalogView()),
                                    child: const Text(
                                      'A little more browsing',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyBag extends StatelessWidget {
  const _EmptyBag({super.key});
  @override
  Widget build(BuildContext context) => Column(
    children: [
      const SizedBox(height: 40),
      Container(
        width: 115,
        height: 115,
        decoration: const BoxDecoration(color: yellow, shape: BoxShape.circle),
        child: const Icon(Icons.shopping_bag_outlined, size: 43),
      ),
      const SizedBox(height: 26),
      const Text(
        'Good things await.',
        style: TextStyle(fontSize: 28, letterSpacing: -1),
      ),
      const SizedBox(height: 10),
      const Text(
        'Your bag is ready for a little feel-good.\nLet’s find something for your daily ritual.',
        textAlign: TextAlign.center,
        style: TextStyle(color: muted, height: 1.7, fontSize: 13),
      ),
      const SizedBox(height: 28),
      ActionButton(
        'Explore the collection',
        onTap: () => navigate(context, const CatalogView()),
      ),
    ],
  );
}

class _CartCard extends StatelessWidget {
  const _CartCard({super.key, required this.item});
  final CartItem item;
  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    final tag = 'cart-${item.id}';
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => navigate(
                context,
                ProductView(product: item.product, heroTag: tag),
              ),
              child: Container(
                width: 77,
                height: 121,
                decoration: BoxDecoration(
                  color: item.product.color.withValues(alpha: .45),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Hero(
                  tag: tag,
                  child: Bottle(product: item.product),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.product.label,
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -.6,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Remove ${item.product.label}',
                        onPressed: () => shop.changeQuantity(item, 0),
                        constraints: const BoxConstraints(
                          minWidth: 30,
                          minHeight: 30,
                        ),
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.close_rounded,
                          size: 17,
                          color: muted,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${item.pack} wafers · ${money(item.product.priceFor(item.pack))} each',
                    style: const TextStyle(fontSize: 10, color: muted),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    money(item.total),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  QuantityControl(
                    quantity: item.quantity,
                    canRemove: true,
                    onChanged: (quantity) =>
                        shop.changeQuantity(item, quantity),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
