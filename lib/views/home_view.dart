import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/shop_widgets.dart';
import 'catalog_view.dart';
import 'product_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _headerAnim;
  late final Animation<double> _titleAnim;
  late final Animation<double> _leftBottleAnim;
  late final Animation<double> _rightBottleAnim;
  late final Animation<double> _subtitleAnim;
  late final Animation<double> _buttonAnim;
  late final Animation<double> _footerAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _headerAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOutCubic),
    );
    _titleAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.08, 0.55, curve: Curves.easeOutCubic),
    );
    _leftBottleAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.20, 0.72, curve: Curves.easeOutCubic),
    );
    _rightBottleAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.30, 0.82, curve: Curves.easeOutCubic),
    );
    _subtitleAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.48, 0.88, curve: Curves.easeOutCubic),
    );
    _buttonAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.62, 1.0, curve: Curves.easeOutCubic),
    );
    _footerAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.75, 1.0, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => Column(
                children: [
                  FadeTransition(
                    opacity: _headerAnim,
                    child: const ShopHeader(back: false, light: true),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Opacity(
                            opacity: _headerAnim.value,
                            child: Transform.translate(
                              offset: Offset(0, -25 * (1 - _headerAnim.value)),
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
                                    onPressed: () =>
                                        showModalBottomSheet<void>(
                                      context: context,
                                      showDragHandle: true,
                                      builder: (_) => const SafeArea(
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              28, 0, 28, 40),
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
                          ),
                          const SizedBox(height: 28),
                          Opacity(
                            opacity: _headerAnim.value,
                            child: Transform.translate(
                              offset: Offset(0, -30 * (1 - _headerAnim.value)),
                              child: const Text(
                                'A LITTLE RITUAL. A LOT OF GOOD.',
                                style: TextStyle(
                                  fontSize: 10,
                                  letterSpacing: 2,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Opacity(
                            opacity: _titleAnim.value,
                            child: Transform.translate(
                              offset: Offset(0, -45 * (1 - _titleAnim.value)),
                              child: const Text(
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
                          ),
                          SizedBox(
                            height: 255,
                            child: LayoutBuilder(
                              builder: (context, box) => Stack(
                                children: [
                                  // Left bottle (Relax) coming from left
                                  Positioned(
                                    left: box.maxWidth * .13,
                                    top: 30,
                                    child: Transform.translate(
                                      offset: Offset(
                                        -260 * (1 - _leftBottleAnim.value),
                                        0,
                                      ),
                                      child: Opacity(
                                        opacity: _leftBottleAnim.value
                                            .clamp(0.0, 1.0),
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
                                    ),
                                  ),
                                  // Right bottle (Sleep) coming from right
                                  Positioned(
                                    right: box.maxWidth * .12,
                                    top: 0,
                                    child: Transform.translate(
                                      offset: Offset(
                                        260 * (1 - _rightBottleAnim.value),
                                        0,
                                      ),
                                      child: Opacity(
                                        opacity: _rightBottleAnim.value
                                            .clamp(0.0, 1.0),
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
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Opacity(
                            opacity: _subtitleAnim.value,
                            child: Transform.translate(
                              offset: Offset(
                                0,
                                -30 * (1 - _subtitleAnim.value),
                              ),
                              child: const Text(
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
                          ),
                          // Button opening from left to right
                          Padding(
                            padding: const EdgeInsets.fromLTRB(28, 25, 28, 18),
                            child: LayoutBuilder(
                              builder: (context, constraints) => ClipRect(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: _buttonAnim.value,
                                  child: SizedBox(
                                    width: constraints.maxWidth,
                                    child: ActionButton(
                                      'Find your feel-good',
                                      onTap: () => navigate(
                                        context,
                                        const CatalogView(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Opacity(
                            opacity: _footerAnim.value,
                            child: const Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Text(
                                'Thoughtful rituals. Made for every day.',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white70,
                                ),
                              ),
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
        ),
      );
}
