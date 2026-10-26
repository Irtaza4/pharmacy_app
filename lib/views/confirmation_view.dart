import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/product_art.dart';
import '../widgets/shop_widgets.dart';
import 'catalog_view.dart';

class ConfirmationView extends StatelessWidget {
  const ConfirmationView({super.key, required this.order});
  final DemoOrder order;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFDCE5D1),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Brand(color: ink),
            const SizedBox(height: 45),
            Reveal(
              child: Container(
                width: 106,
                height: 106,
                decoration: const BoxDecoration(
                  color: ink,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, color: yellow, size: 49),
              ),
            ),
            const SizedBox(height: 28),
            const Reveal(
              delay: 100,
              child: Text(
                'Good things.\nComing your way.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 39,
                  height: 1.08,
                  letterSpacing: -2,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Thanks, ${order.name.split(' ').first}.\nYour demo order is all wrapped up.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                height: 1.7,
                color: Color(0xFF68745F),
              ),
            ),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: cream,
                borderRadius: BorderRadius.circular(27),
              ),
              child: Column(
                children: [
                  SummaryRow('Demo order', order.number),
                  const Divider(),
                  ...order.items.map(
                    (item) => SummaryRow(
                      '${item.product.label} ${item.pack} × ${item.quantity}',
                      money(item.total),
                    ),
                  ),
                  SummaryRow(
                    'Delivery',
                    order.shipping == 0 ? 'On us' : money(order.shipping),
                  ),
                  const Divider(),
                  SummaryRow('Total', money(order.total), bold: true),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'This was a demo. No payment was taken,\nno email was sent, and no items will ship.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                height: 1.7,
                color: Color(0xFF68745F),
              ),
            ),
            const SizedBox(height: 26),
            ActionButton(
              'Keep feeling good',
              dark: true,
              onTap: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
                navigate(context, const CatalogView());
              },
            ),
          ],
        ),
      ),
    ),
  );
}
