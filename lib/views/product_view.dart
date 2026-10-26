import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../viewmodels/product_view_model.dart';
import '../viewmodels/shop_view_model.dart';
import '../widgets/product_art.dart';
import '../widgets/shop_widgets.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key, required this.product, required this.heroTag});
  final Product product;
  final String heroTag;
  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  late final model = ProductViewModel(widget.product);
  final bottleKey = GlobalKey(), bagKey = GlobalKey();
  bool adding = false;
  @override
  void dispose() {
    model.dispose();
    super.dispose();
  }

  Future<void> add() async {
    if (adding) return;
    setState(() => adding = true);
    final shop = ShopScope.of(context);
    final pack = model.pack, quantity = model.quantity;
    await flyToBag(context, bottleKey, bagKey, model.product);
    if (!mounted) return;
    shop.add(model.product, pack: pack, quantity: quantity);
    setState(() => adding = false);
    addedMessage(context, model.product);
  }

  @override
  Widget build(BuildContext context) {
    final product = model.product;
    final shop = ShopScope.of(context);
    final foreground = product.isDark ? Colors.white : ink;
    return Scaffold(
      backgroundColor: product.color,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              product.color,
              Color.lerp(product.color, Colors.white, .22)!,
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              ShopHeader(light: product.isDark, bagKey: bagKey),
              Expanded(
                child: AnimatedBuilder(
                  animation: model,
                  builder: (context, _) => SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 26,
                            vertical: 5,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                product == Product.sleep
                                    ? Icons.nightlight_outlined
                                    : Icons.filter_vintage_outlined,
                                color: foreground,
                                size: 17,
                              ),
                              const SizedBox(width: 7),
                              Text(
                                product.category,
                                style: TextStyle(
                                  color: foreground,
                                  fontSize: 12,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                tooltip: 'Save ${product.label}',
                                onPressed: () => shop.favorite(product),
                                icon: Icon(
                                  shop.favorites.contains(product)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: foreground,
                                  size: 21,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 295,
                          width: double.infinity,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: LeafPainter(
                                    color: foreground.withValues(alpha: .04),
                                  ),
                                ),
                              ),
                              Center(
                                child: SizedBox(
                                  key: bottleKey,
                                  width: 190,
                                  height: 285,
                                  child: ProductObject(
                                    product: product,
                                    tag: widget.heroTag,
                                    pack: model.pack,
                                    quantity: model.quantity,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 24,
                                top: 18,
                                child: Column(
                                  children: [30, 60, 90]
                                      .map(
                                        (size) => Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 8,
                                          ),
                                          child: Semantics(
                                            selected: model.pack == size,
                                            child: InkWell(
                                              onTap: () =>
                                                  model.selectPack(size),
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              child: AnimatedContainer(
                                                duration: const Duration(
                                                  milliseconds: 250,
                                                ),
                                                width: 42,
                                                height: 42,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: model.pack == size
                                                      ? (product.isDark
                                                            ? cream
                                                            : ink)
                                                      : Colors.black.withValues(
                                                          alpha: .08,
                                                        ),
                                                ),
                                                child: Text(
                                                  '$size',
                                                  style: TextStyle(
                                                    color: model.pack == size
                                                        ? (product.isDark
                                                              ? ink
                                                              : cream)
                                                        : foreground.withValues(
                                                            alpha: .55,
                                                          ),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                              Positioned(
                                bottom: 2,
                                left: 0,
                                right: 0,
                                child: IgnorePointer(
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 200),
                                    child: Text(
                                      shop.dragging
                                          ? 'Drop it on the bag ↑'
                                          : 'Drag your little boost to the bag',
                                      key: ValueKey(shop.dragging),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: foreground.withValues(
                                          alpha: .65,
                                        ),
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(26, 27, 26, 20),
                          decoration: const BoxDecoration(
                            color: cream,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(36),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      product.subtitle.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 9,
                                        letterSpacing: 1.6,
                                        fontWeight: FontWeight.w700,
                                        color: muted,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.star_rounded,
                                    size: 14,
                                    color: Color(0xFFC3A53A),
                                  ),
                                  const Text(
                                    ' 4.9',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '${product.label} ${model.pack}\nDissolvable Wafers',
                                style: const TextStyle(
                                  fontSize: 32,
                                  height: 1.12,
                                  letterSpacing: -1.6,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                product.description,
                                style: const TextStyle(
                                  fontSize: 12,
                                  height: 1.7,
                                  color: muted,
                                ),
                              ),
                              const SizedBox(height: 22),
                              Row(
                                children: [
                                  Expanded(
                                    child: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 180,
                                      ),
                                      child: Align(
                                        key: ValueKey(model.total),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          money(model.total),
                                          style: const TextStyle(
                                            fontSize: 29,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: -1.2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  QuantityControl(
                                    quantity: model.quantity,
                                    onChanged: model.changeQuantity,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 21),
                              ActionButton(
                                adding ? 'On its way…' : 'Add to bag',
                                icon: Icons.shopping_bag_outlined,
                                onTap: adding ? null : add,
                              ),
                              const SizedBox(height: 20),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.local_shipping_outlined,
                                    size: 16,
                                    color: muted,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Free delivery on orders \$60+',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: muted,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Theme(
                                data: Theme.of(
                                  context,
                                ).copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  tilePadding: EdgeInsets.zero,
                                  title: const Text(
                                    'The little details',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 18,
                                      ),
                                      child: Text(
                                        '${model.pack} individually portioned dissolvable wafers. Store in a cool, dry place. This is a concept product; ingredients and product information will be supplied by the store.',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          height: 1.7,
                                          color: muted,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.paddingOf(context).bottom,
                              ),
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
      ),
    );
  }
}
