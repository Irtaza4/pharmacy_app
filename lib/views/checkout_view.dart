import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../viewmodels/checkout_view_model.dart';
import '../viewmodels/shop_view_model.dart';
import '../widgets/product_art.dart';
import '../widgets/shop_widgets.dart';
import 'confirmation_view.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});
  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  CheckoutViewModel? _model;
  final form = GlobalKey<FormState>();
  final scroll = ScrollController();
  CheckoutViewModel get model => _model!;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _model ??= CheckoutViewModel(ShopScope.of(context));
  }

  @override
  void dispose() {
    model.dispose();
    scroll.dispose();
    super.dispose();
  }

  void top() => scroll.animateTo(
    0,
    duration: const Duration(milliseconds: 350),
    curve: Curves.easeOut,
  );
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          const ShopHeader(showBag: false),
          Expanded(
            child: AnimatedBuilder(
              animation: model,
              builder: (context, _) => SingleChildScrollView(
                controller: scroll,
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ALMOST YOURS.',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 1.8,
                        color: muted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'A little closer\nto feeling good.',
                      style: TextStyle(
                        fontSize: 36,
                        height: 1.1,
                        letterSpacing: -1.8,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        step('1', 'Delivery', model.step == 0),
                        const Expanded(
                          child: Divider(indent: 12, endIndent: 12),
                        ),
                        step('2', 'Review', model.step == 1),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8EDE2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline_rounded, size: 18),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Try the full journey. This demo won’t charge you or send an order.',
                              style: TextStyle(fontSize: 11, height: 1.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    if (model.shop.items.isEmpty) ...[
                      const Text(
                        'Your bag is empty. Add a little boost before checking out.',
                      ),
                      const SizedBox(height: 20),
                      ActionButton(
                        'Back to bag',
                        onTap: () => Navigator.pop(context),
                      ),
                    ] else
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: model.step == 0 ? delivery() : review(),
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

  Widget step(String number, String label, bool selected) => Row(
    children: [
      AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 29,
        height: 29,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? ink : const Color(0xFFE3E7DC),
        ),
        child: Text(
          number,
          style: TextStyle(fontSize: 12, color: selected ? cream : muted),
        ),
      ),
      const SizedBox(width: 8),
      Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: selected ? ink : muted,
        ),
      ),
    ],
  );

  Widget field(
    String label,
    String value,
    ValueChanged<String> changed, {
    bool email = false,
    TextInputType? keyboard,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13),
      ),
      keyboardType: email ? TextInputType.emailAddress : keyboard,
      textInputAction: TextInputAction.next,
      textCapitalization: email
          ? TextCapitalization.none
          : TextCapitalization.words,
      autocorrect: !email,
      validator: email ? model.validateEmail : model.requiredField,
      onChanged: changed,
    ),
  );

  Widget delivery() => Form(
    key: form,
    child: Column(
      key: const ValueKey('delivery'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Where should your good go?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: -.5,
          ),
        ),
        const SizedBox(height: 18),
        field('Full name', model.name, (v) => model.name = v),
        field(
          'Email address',
          model.email,
          (v) => model.email = v,
          email: true,
        ),
        field('Street address', model.address, (v) => model.address = v),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: field('City', model.city, (v) => model.city = v)),
            const SizedBox(width: 12),
            Expanded(
              child: field(
                'Postal code',
                model.postal,
                (v) => model.postal = v,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Make it your delivery',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: -.5,
          ),
        ),
        const SizedBox(height: 14),
        deliveryOption(
          false,
          'Slow & steady',
          'Standard · 3–5 business days',
          model.shop.shipping == 0 ? 'Free' : money(model.shop.shipping),
        ),
        const SizedBox(height: 10),
        deliveryOption(
          true,
          'A little sooner',
          'Express · 1–2 business days',
          '\$9.95',
        ),
        const SizedBox(height: 22),
        ActionButton(
          'Review your order',
          onTap: () {
            if (form.currentState!.validate()) {
              FocusScope.of(context).unfocus();
              model.review();
              top();
            }
          },
        ),
      ],
    ),
  );

  Widget deliveryOption(
    bool express,
    String title,
    String subtitle,
    String price,
  ) => InkWell(
    onTap: () => model.selectDelivery(express),
    borderRadius: BorderRadius.circular(19),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: model.express == express
            ? const Color(0xFFEEF0DC)
            : Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: model.express == express ? ink : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Icon(
            model.express == express
                ? Icons.radio_button_checked
                : Icons.radio_button_off,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 10, color: muted),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ),
  );

  Widget review() => Column(
    key: const ValueKey('review'),
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          const Expanded(
            child: Text(
              'Looking good.',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                letterSpacing: -.7,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              model.edit();
              top();
            },
            child: const Text('Edit details'),
          ),
        ],
      ),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'DELIVER TO',
              style: TextStyle(fontSize: 9, letterSpacing: 1.5, color: muted),
            ),
            const SizedBox(height: 10),
            Text(
              model.name,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 5),
            Text(
              '${model.address}\n${model.city}, ${model.postal}\n${model.email}',
              style: const TextStyle(fontSize: 12, height: 1.8, color: muted),
            ),
            const SizedBox(height: 12),
            Text(
              model.express
                  ? 'Express delivery · 1–2 business days'
                  : 'Standard delivery · 3–5 business days',
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
      const SizedBox(height: 22),
      ...model.shop.items.map(
        (item) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 59,
                decoration: BoxDecoration(
                  color: item.product.color.withValues(alpha: .35),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Bottle(product: item.product),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${item.product.label} ${item.pack}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Quantity ${item.quantity}',
                      style: const TextStyle(fontSize: 11, color: muted),
                    ),
                  ],
                ),
              ),
              Text(
                money(item.total),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 10),
      const Divider(),
      SummaryRow('Subtotal', money(model.shop.subtotal)),
      SummaryRow(
        'Delivery',
        model.shipping == 0 ? 'On us' : money(model.shipping),
      ),
      SummaryRow('Total', money(model.total), bold: true),
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Row(
          children: [
            Icon(Icons.credit_card_outlined),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Demo payment',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  Text(
                    'No card details needed. Nothing is charged.',
                    style: TextStyle(fontSize: 10, color: muted),
                  ),
                ],
              ),
            ),
            Icon(Icons.check_circle_outline, size: 20),
          ],
        ),
      ),
      const SizedBox(height: 22),
      ActionButton(
        'Place demo order',
        icon: Icons.check_rounded,
        onTap: () {
          final order = model.submit();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(
              builder: (_) => ConfirmationView(order: order),
            ),
          );
        },
      ),
      const SizedBox(height: 14),
      const Center(
        child: Text(
          'Your details stay in this session only.',
          style: TextStyle(fontSize: 10, color: muted),
        ),
      ),
    ],
  );
}
