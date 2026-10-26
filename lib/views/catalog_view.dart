import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../viewmodels/catalog_view_model.dart';
import '../viewmodels/shop_view_model.dart';
import '../widgets/product_art.dart';
import '../widgets/shop_widgets.dart';
import 'product_view.dart';

class CatalogView extends StatefulWidget {
  const CatalogView({super.key});
  @override
  State<CatalogView> createState() => _CatalogViewState();
}

class _CatalogViewState extends State<CatalogView> {
  CatalogViewModel? _model;
  CatalogViewModel get model => _model!;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _model ??= CatalogViewModel(ShopScope.of(context).products);
  }

  @override
  void dispose() {
    model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const ShopHeader(),
            Expanded(
              child: AnimatedBuilder(
                animation: model,
                builder: (context, _) {
                  final products = model.visible(shop.favorites);
                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 10, 24, 22),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Reveal(
                                child: Text(
                                  'YOUR DAILY FEEL-GOOD',
                                  style: TextStyle(
                                    fontSize: 10,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.w700,
                                    color: muted,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Reveal(
                                child: Text(
                                  'Good things.\nSmall packages.',
                                  style: TextStyle(
                                    fontSize: 38,
                                    height: 1.08,
                                    letterSpacing: -1.9,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Find a little boost for your everyday rituals.',
                                style: TextStyle(color: muted, fontSize: 13),
                              ),
                              const SizedBox(height: 22),
                              TextField(
                                onChanged: model.search,
                                decoration: const InputDecoration(
                                  hintText: 'Find your feel-good',
                                  prefixIcon: Icon(
                                    Icons.search_rounded,
                                    size: 21,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children:
                                      ['All', 'Unwind', 'Everyday', 'Saved']
                                          .map(
                                            (category) => Padding(
                                              padding: const EdgeInsets.only(
                                                right: 8,
                                              ),
                                              child: ChoiceChip(
                                                label: Text(category),
                                                selected:
                                                    model.category == category,
                                                onSelected: (_) =>
                                                    model.filter(category),
                                                showCheckmark: false,
                                                selectedColor: ink,
                                                backgroundColor: cream,
                                                labelStyle: TextStyle(
                                                  color:
                                                      model.category == category
                                                      ? Colors.white
                                                      : ink,
                                                  fontSize: 12,
                                                ),
                                                side: const BorderSide(
                                                  color: Color(0xFFE0E4D9),
                                                ),
                                                shape: const StadiumBorder(),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                spacing: 18,
                                runSpacing: 8,
                                children: [
                                  Text(
                                    '${products.length} little boosts',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: muted,
                                    ),
                                  ),
                                  const Text(
                                    'Hold & drag to bag',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: muted,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (products.isEmpty)
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(35),
                            child: Text(
                              'No products here yet.\nTry another search or save a favorite.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: muted, height: 1.7),
                            ),
                          ),
                        ),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => Reveal(
                              key: ValueKey(products[index]),
                              delay: index * 45,
                              child: _ProductCard(product: products[index]),
                            ),
                            childCount: products.length,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 14,
                                mainAxisExtent: 278,
                              ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            24,
                            0,
                            24,
                            24 + MediaQuery.paddingOf(context).bottom,
                          ),
                          child: const Text(
                            'Good things come with a little care.\nFree standard delivery on orders of \$60 or more.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: muted,
                              fontSize: 11,
                              height: 1.7,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});
  final Product product;
  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    final tag = 'catalog-${product.name}';
    void open() =>
        navigate(context, ProductView(product: product, heroTag: tag));
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.lerp(product.color, Colors.white, .25)!,
                    product.color,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: LeafPainter(color: ink.withValues(alpha: .035)),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      width: 110,
                      height: 165,
                      child: ProductObject(
                        product: product,
                        tag: tag,
                        longPress: true,
                        onTap: open,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 3,
                    right: 3,
                    child: IconButton(
                      tooltip: 'Save ${product.label}',
                      onPressed: () => shop.favorite(product),
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        child: Icon(
                          shop.favorites.contains(product)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          key: ValueKey(shop.favorites.contains(product)),
                          size: 18,
                          color: product.isDark ? Colors.white : ink,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(13, 12, 9, 10),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: open,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.label,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -.7,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          '30 dissolvable wafers',
                          style: TextStyle(fontSize: 9, color: muted),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          money(product.basePrice),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Add ${product.label}',
                  onPressed: () {
                    shop.add(product);
                    addedMessage(context, product);
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: cream,
                    minimumSize: const Size(36, 36),
                  ),
                  icon: const Icon(Icons.add, size: 19),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
