import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../viewmodels/shop_view_model.dart';
import '../views/cart_view.dart';
import 'product_art.dart';

void navigate(BuildContext context, Widget view) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  final reduced = MediaQuery.disableAnimationsOf(context);
  Navigator.of(context).push(
    PageRouteBuilder<void>(
      transitionDuration: Duration(milliseconds: reduced ? 0 : 620),
      reverseTransitionDuration: Duration(milliseconds: reduced ? 0 : 450),
      pageBuilder: (_, animation, secondary) => view,
      transitionsBuilder: (_, animation, secondary, child) => FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: const Interval(0, .65),
        ),
        child: child,
      ),
    ),
  );
}

class Reveal extends StatelessWidget {
  const Reveal({super.key, required this.child, this.delay = 0});
  final Widget child;
  final int delay;
  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 650 + delay),
      curve: Curves.easeOutCubic,
      builder: (_, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 22 * (1 - value)),
          child: child,
        ),
      ),
      child: child,
    );
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton(
    this.label, {
    super.key,
    required this.onTap,
    this.icon = Icons.arrow_forward_rounded,
    this.dark = false,
  });
  final String label;
  final VoidCallback? onTap;
  final IconData icon;
  final bool dark;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 56,
    child: FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        backgroundColor: dark ? ink : yellow,
        foregroundColor: dark ? Colors.white : ink,
        shape: const StadiumBorder(),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
          Icon(icon, size: 20),
        ],
      ),
    ),
  );
}

class RoundButton extends StatelessWidget {
  const RoundButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = Colors.white,
    this.foreground = ink,
  });
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color color, foreground;
  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: label,
    onPressed: onTap,
    style: IconButton.styleFrom(
      backgroundColor: color,
      foregroundColor: foreground,
      disabledBackgroundColor: color.withValues(alpha: .5),
      minimumSize: const Size(44, 44),
    ),
    icon: Icon(icon, size: 20),
  );
}

class ShopHeader extends StatelessWidget {
  const ShopHeader({
    super.key,
    this.back = true,
    this.light = false,
    this.bagKey,
    this.showBag = true,
  });
  final bool back, light, showBag;
  final GlobalKey? bagKey;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
    child: Row(
      children: [
        if (back) ...[
          RoundButton(
            icon: Icons.arrow_back_rounded,
            label: 'Back',
            onTap: () => Navigator.maybePop(context),
            color: Colors.white.withValues(alpha: light ? .15 : .8),
            foreground: light ? Colors.white : ink,
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Brand(color: light ? Colors.white : ink),
          ),
        ),
        if (showBag) BagTarget(key: bagKey),
      ],
    ),
  );
}

class BagTarget extends StatelessWidget {
  const BagTarget({super.key});
  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    return DragTarget<CartItem>(
      onWillAcceptWithDetails: (_) => true,
      onAcceptWithDetails: (details) {
        final item = details.data;
        shop.add(item.product, pack: item.pack, quantity: item.quantity);
        addedMessage(context, item.product);
      },
      builder: (context, candidates, rejected) => AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: candidates.isNotEmpty ? 1.22 : 1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: shop.dragging ? yellow : Colors.transparent,
            boxShadow: shop.dragging
                ? [
                    BoxShadow(
                      color: yellow.withValues(alpha: .4),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ]
                : [],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              RoundButton(
                icon: candidates.isNotEmpty
                    ? Icons.add_rounded
                    : Icons.shopping_bag_outlined,
                label: 'Open bag',
                onTap: () => navigate(context, const CartView()),
              ),
              if (shop.count > 0)
                Positioned(
                  right: -1,
                  top: -1,
                  child: IgnorePointer(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                      child: Container(
                        key: ValueKey(shop.count),
                        padding: const EdgeInsets.all(5),
                        constraints: const BoxConstraints(minWidth: 21),
                        decoration: const BoxDecoration(
                          color: ink,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${shop.count}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

void addedMessage(BuildContext context, Product product) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 2),
      content: Text('${product.label} added to your bag'),
      action: SnackBarAction(
        label: 'View bag',
        textColor: yellow,
        onPressed: () => navigate(context, const CartView()),
      ),
    ),
  );
}

class ProductObject extends StatelessWidget {
  const ProductObject({
    super.key,
    required this.product,
    required this.tag,
    this.pack = 30,
    this.quantity = 1,
    this.onTap,
    this.longPress = false,
  });
  final Product product;
  final String tag;
  final int pack, quantity;
  final VoidCallback? onTap;
  final bool longPress;
  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    final art = Hero(
      tag: tag,
      createRectTween: (begin, end) =>
          MaterialRectCenterArcTween(begin: begin, end: end),
      child: Bottle(product: product),
    );
    final child = Semantics(
      label: '${product.label} product. Drag to the shopping bag',
      button: onTap != null,
      child: GestureDetector(onTap: onTap, child: art),
    );
    final feedback = Material(
      color: Colors.transparent,
      child: Transform.rotate(
        angle: -.18,
        child: SizedBox(
          width: 92,
          height: 138,
          child: Bottle(product: product),
        ),
      ),
    );
    if (longPress) {
      return LongPressDraggable<CartItem>(
        data: CartItem(product, pack, quantity),
        delay: const Duration(milliseconds: 250),
        feedback: feedback,
        onDragStarted: () => shop.setDragging(true),
        onDragEnd: (_) => shop.setDragging(false),
        childWhenDragging: Opacity(
          opacity: .2,
          child: Bottle(product: product),
        ),
        child: child,
      );
    }
    return Draggable<CartItem>(
      data: CartItem(product, pack, quantity),
      feedback: feedback,
      onDragStarted: () => shop.setDragging(true),
      onDragEnd: (_) => shop.setDragging(false),
      childWhenDragging: Opacity(opacity: .2, child: Bottle(product: product)),
      child: child,
    );
  }
}

Future<void> flyToBag(
  BuildContext context,
  GlobalKey source,
  GlobalKey destination,
  Product product,
) async {
  if (MediaQuery.disableAnimationsOf(context)) return;
  final from = source.currentContext?.findRenderObject();
  final to = destination.currentContext?.findRenderObject();
  final overlay = Overlay.of(context);
  final overlayBox = overlay.context.findRenderObject();
  if (from is! RenderBox || to is! RenderBox || overlayBox is! RenderBox) {
    return;
  }
  final begin = overlayBox.globalToLocal(
    from.localToGlobal(from.size.center(Offset.zero)),
  );
  final end = overlayBox.globalToLocal(
    to.localToGlobal(to.size.center(Offset.zero)),
  );
  final entry = OverlayEntry(
    builder: (context) => TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeInOutCubic,
      builder: (_, t, child) {
        final center =
            Offset.lerp(begin, end, t)! +
            Offset(-55 * math.sin(t * math.pi), -65 * math.sin(t * math.pi));
        return Positioned(
          left: center.dx - 45,
          top: center.dy - 65,
          child: IgnorePointer(
            child: Opacity(
              opacity: 1 - t * .6,
              child: Transform.scale(scale: 1 - t * .7, child: child),
            ),
          ),
        );
      },
      child: SizedBox(width: 90, height: 130, child: Bottle(product: product)),
    ),
  );
  overlay.insert(entry);
  await Future<void>.delayed(const Duration(milliseconds: 660));
  entry.remove();
  entry.dispose();
}

class QuantityControl extends StatelessWidget {
  const QuantityControl({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.canRemove = false,
  });
  final int quantity;
  final ValueChanged<int> onChanged;
  final bool canRemove;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      RoundButton(
        icon: quantity == 1 && canRemove ? Icons.delete_outline : Icons.remove,
        label: 'Decrease quantity',
        onTap: quantity > 1 || canRemove ? () => onChanged(quantity - 1) : null,
        color: const Color(0xFFE8EBE1),
      ),
      SizedBox(
        width: 32,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: Text(
            '$quantity',
            key: ValueKey(quantity),
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
      RoundButton(
        icon: Icons.add,
        label: 'Increase quantity',
        onTap: quantity < 99 ? () => onChanged(quantity + 1) : null,
        color: ink,
        foreground: yellow,
      ),
    ],
  );
}

class SummaryRow extends StatelessWidget {
  const SummaryRow(this.label, this.value, {super.key, this.bold = false});
  final String label, value;
  final bool bold;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: bold ? ink : muted,
              fontSize: bold ? 22 : 14,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 24 : 14,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
