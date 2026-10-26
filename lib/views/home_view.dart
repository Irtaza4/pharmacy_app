import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/shop_widgets.dart';
import 'catalog_view.dart';
import 'product_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF527F9B), Color(0xFF9ABAC8)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const ShopHeader(back: false, light: true),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Reveal(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () =>
                                navigate(context, const CatalogView()),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.white.withValues(
                                alpha: .1,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                            ),
                            child: const Text('Products'),
                          ),
                          const SizedBox(width: 12),
                          TextButton(
                            onPressed: () => showModalBottomSheet<void>(
                              context: context,
                              showDragHandle: true,
                              builder: (_) => const SafeArea(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(28, 0, 28, 40),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Small rituals.\nGood days.',
                                        style: TextStyle(
                                          fontSize: 34,
                                          height: 1.1,
                                          letterSpacing: -1.5,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'Meet a colorful collection for your everyday rituals. Explore the range, find your favorites, and make a little time for yourself.',
                                        style: TextStyle(height: 1.7),
                                      ),
                                      SizedBox(height: 18),
                                      Text(
                                        'A design concept by xefag. Products and checkout in this app are a demo.',
                                        style: TextStyle(
                                          color: muted,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white70,
                            ),
                            child: const Text('Our story'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Reveal(
                      delay: 50,
                      child: Text(
                        'A LITTLE RITUAL. A LOT OF GOOD.',
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 2,
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Reveal(
                      delay: 100,
                      child: Text(
                        'Powerful\nBoost',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 61,
                          height: .98,
                          letterSpacing: -3.3,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 255,
                      child: LayoutBuilder(
                        builder: (context, box) => Stack(
                          children: [
                            Positioned(
                              left: box.maxWidth * .13,
                              top: 30,
                              child: Transform.rotate(
                                angle: -.18,
                                child: SizedBox(
                                  width: 145,
                                  height: 220,
                                  child: ProductObject(
                                    product: Product.relax,
                                    tag: 'home-relax',
                                    onTap: () => navigate(
                                      context,
                                      const ProductView(
                                        product: Product.relax,
                                        heroTag: 'home-relax',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: box.maxWidth * .12,
                              top: 0,
                              child: Transform.rotate(
                                angle: .22,
                                child: SizedBox(
                                  width: 145,
                                  height: 220,
                                  child: ProductObject(
                                    product: Product.sleep,
                                    tag: 'home-sleep',
                                    onTap: () => navigate(
                                      context,
                                      const ProductView(
                                        product: Product.sleep,
                                        heroTag: 'home-sleep',
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
                    const Reveal(
                      delay: 200,
                      child: Text(
                        'Helping humans become\nhappier & healthier.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          height: 1.2,
                          letterSpacing: -.8,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(28, 25, 28, 18),
                      child: Reveal(
                        delay: 250,
                        child: ActionButton(
                          'Find your feel-good',
                          onTap: () => navigate(context, const CatalogView()),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text(
                        'Thoughtful rituals. Made for every day.',
                        style: TextStyle(fontSize: 11, color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
