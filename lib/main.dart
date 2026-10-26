import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Color(0xFFBFD9E6),
    ),
  );
  runApp(const MyApp());
}

const ink = Color(0xFF20251F);
const yellow = Color(0xFFF5D44E);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'xefag — Feel your best',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      fontFamily: 'Helvetica Neue',
      colorScheme: ColorScheme.fromSeed(seedColor: yellow, onSurface: ink),
      scaffoldBackgroundColor: const Color(0xFFBFD9E6),
      textTheme: const TextTheme(bodyMedium: TextStyle(color: ink)),
    ),
    home: const PharmacyHome(),
  );
}

enum Product { relax, sleep }

extension ProductDetails on Product {
  String get label => this == Product.relax ? 'Relax' : 'Sleep';
  Color get color => this == Product.relax ? yellow : const Color(0xFFAA2447);
}

class PharmacyHome extends StatefulWidget {
  const PharmacyHome({super.key});
  @override
  State<PharmacyHome> createState() => _PharmacyHomeState();
}

class _PharmacyHomeState extends State<PharmacyHome> {
  Product? selected;
  int pack = 30;
  int quantity = 1;
  final Map<(Product, int), int> bag = {};
  int get bagCount => bag.values.fold(0, (sum, n) => sum + n);
  double price(int size) => 25.50 * size / 30;

  void openProduct(Product product) => setState(() {
    selected = product;
    quantity = 1;
    pack = 30;
  });

  void showBag() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF9FAF5),
      builder: (context) => StatefulBuilder(
        builder: (context, update) {
          final total = bag.entries.fold<double>(
            0,
            (sum, e) => sum + price(e.key.$2) * e.value,
          );
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(26, 24, 26, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Your bag',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (bag.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Text(
                        'A little wellbeing is waiting for you.\nExplore Sleep and Relax to fill your bag.',
                        style: TextStyle(fontSize: 16, height: 1.6),
                      ),
                    ),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        children: bag.entries
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 54,
                                      height: 68,
                                      decoration: BoxDecoration(
                                        color: e.key.$1.color.withValues(
                                          alpha: .35,
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Bottle(product: e.key.$1),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${e.key.$1.label} ${e.key.$2}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                            ),
                                          ),
                                          Text(
                                            '${e.value} × \$${price(e.key.$2).toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      tooltip: 'Remove ${e.key.$1.label}',
                                      onPressed: () {
                                        setState(() => bag.remove(e.key));
                                        update(() {});
                                      },
                                      icon: const Icon(Icons.delete_outline),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  if (bag.isNotEmpty) ...[
                    const Divider(),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total', style: TextStyle(fontSize: 20)),
                        Text(
                          '\$${total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Demo shopping bag · checkout is not connected',
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void showInfo(bool account) => showModalBottomSheet<void>(
    context: context,
    backgroundColor: const Color(0xFFF9FAF5),
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              account ? 'Welcome to xefag' : 'A little boost. A better day.',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Text(
              account
                  ? 'Explore our products and build your bag. Account sign-in will be available when the store is connected.'
                  : 'Flexible solutions for all kinds of people. Discover our Sleep and Relax dissolvable wafers, made to fit into your everyday routine.',
              style: const TextStyle(fontSize: 17, height: 1.5),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              style: FilledButton.styleFrom(backgroundColor: ink),
              child: const Text('Got it'),
            ),
          ],
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final product = selected;
    final isSleep = product == Product.sleep;
    final foreground = product == Product.relax ? ink : Colors.white;
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 450),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: product == null
                    ? [const Color(0xFF5285A6), const Color(0xFF97B9C8)]
                    : isSleep
                    ? [
                        const Color(0xFF9C1638),
                        const Color(0xFFB63655),
                        const Color(0xFF8E1E3A),
                      ]
                    : [
                        const Color(0xFFF3C333),
                        const Color(0xFFFFE16A),
                        const Color(0xFFEFC63D),
                      ],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 18, 20, 0),
                    child: Row(
                      children: [
                        if (product != null) ...[
                          CircleControl(
                            icon: Icons.chevron_left,
                            label: 'Back to home',
                            color: isSleep
                                ? Colors.white.withValues(alpha: .12)
                                : Colors.white,
                            foreground: foreground == ink ? ink : Colors.white,
                            onTap: () => setState(() => selected = null),
                          ),
                          const SizedBox(width: 14),
                        ],
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Brand(color: foreground),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        CircleControl(
                          icon: Icons.person_outline,
                          label: 'Account',
                          color: Colors.black.withValues(alpha: .08),
                          foreground: foreground,
                          onTap: () => showInfo(true),
                        ),
                        const SizedBox(width: 10),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CircleControl(
                              icon: Icons.shopping_bag_outlined,
                              label: 'Open bag',
                              color: Colors.white,
                              foreground: ink,
                              onTap: showBag,
                            ),
                            if (bagCount > 0)
                              Positioned(
                                right: -4,
                                top: -4,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: ink,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '$bagCount',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      child: product == null ? landing() : productPage(product),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget landing() => LayoutBuilder(
    key: const ValueKey('landing'),
    builder: (context, constraints) => SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: Column(
          children: [
            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                pill('Products', () => openProduct(Product.relax)),
                const SizedBox(width: 10),
                pill('Contact', () => showInfo(false)),
              ],
            ),
            const SizedBox(height: 38),
            Text(
              'Flexible solutions\nfor all kind of people',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.25,
                color: Colors.white.withValues(alpha: .75),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Powerful\nBoost',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 57,
                height: .98,
                letterSpacing: -2.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: constraints.maxHeight > 740 ? 310 : 265,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 34,
                    top: 38,
                    child: GestureDetector(
                      onTap: () => openProduct(Product.relax),
                      child: Semantics(
                        button: true,
                        label: 'Explore Relax',
                        child: Transform.rotate(
                          angle: -.19,
                          child: const SizedBox(
                            width: 158,
                            height: 232,
                            child: Bottle(product: Product.relax),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 29,
                    top: 4,
                    child: GestureDetector(
                      onTap: () => openProduct(Product.sleep),
                      child: Semantics(
                        button: true,
                        label: 'Explore Sleep',
                        child: Transform.rotate(
                          angle: .25,
                          child: const SizedBox(
                            width: 158,
                            height: 232,
                            child: Bottle(product: Product.sleep),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'FEEL YOUR BEST',
              style: TextStyle(
                color: Colors.white.withValues(alpha: .5),
                fontSize: 10,
                letterSpacing: 2.2,
              ),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Helping humans\nbecome happier &\nhealthier!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  height: 1.12,
                  letterSpacing: -.6,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => openProduct(Product.relax),
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Discover your boost'),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
  );

  Widget pill(String title, VoidCallback action) => InkWell(
    onTap: action,
    borderRadius: BorderRadius.circular(30),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .07),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: .15)),
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 12, color: Colors.white),
      ),
    ),
  );

  Widget productPage(Product product) {
    final dark = product == Product.sleep;
    final foreground = dark ? Colors.white : ink;
    return LayoutBuilder(
      key: ValueKey(product),
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 26, 24, 0),
                  child: Row(
                    children: Product.values
                        .map(
                          (p) => Padding(
                            padding: const EdgeInsets.only(right: 23),
                            child: InkWell(
                              onTap: () => openProduct(p),
                              borderRadius: BorderRadius.circular(20),
                              child: Opacity(
                                opacity: p == product ? 1 : .4,
                                child: Row(
                                  children: [
                                    Icon(
                                      p == Product.relax
                                          ? Icons.filter_vintage_outlined
                                          : Icons.nightlight_outlined,
                                      size: 17,
                                      color: foreground,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      p.label,
                                      style: TextStyle(
                                        color: foreground,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    height: math.max(290, constraints.maxHeight - 340),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: CustomPaint(
                            painter: LeafPainter(
                              color: foreground.withValues(alpha: .035),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SizedBox(
                            width: 200,
                            height: 300,
                            child: Bottle(product: product),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 23,
                          child: Column(
                            children: [30, 60, 90]
                                .map(
                                  (size) => Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: InkWell(
                                      onTap: () => setState(() => pack = size),
                                      borderRadius: BorderRadius.circular(50),
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 180,
                                        ),
                                        width: 36,
                                        height: 36,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: size == pack
                                              ? (dark ? Colors.white : ink)
                                              : Colors.black.withValues(
                                                  alpha: .13,
                                                ),
                                        ),
                                        child: Text(
                                          '$size',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: size == pack
                                                ? (dark ? ink : Colors.white)
                                                : foreground.withValues(
                                                    alpha: .45,
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
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(27, 28, 27, 22),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8FAF6),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(36),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${product.label} $pack\nDissolvable Wafers',
                          style: const TextStyle(
                            fontSize: 30,
                            height: 1.08,
                            letterSpacing: -1.2,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          product == Product.sleep ? '200 mg' : '250 mg',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF9D9F98),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    '\$${(price(pack) * quantity).toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: -1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            CircleControl(
                              icon: Icons.remove,
                              label: 'Decrease quantity',
                              color: ink,
                              foreground: yellow,
                              onTap: quantity > 1
                                  ? () => setState(() => quantity--)
                                  : null,
                            ),
                            SizedBox(
                              width: 39,
                              child: Text(
                                '$quantity',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            CircleControl(
                              icon: Icons.add,
                              label: 'Increase quantity',
                              color: ink,
                              foreground: yellow,
                              onTap: () => setState(() => quantity++),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: FilledButton(
                            onPressed: () {
                              setState(
                                () => bag.update(
                                  (product, pack),
                                  (n) => n + quantity,
                                  ifAbsent: () => quantity,
                                ),
                              );
                              showBag();
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: yellow,
                              foregroundColor: ink,
                              shape: const StadiumBorder(),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.shopping_bag_outlined, size: 17),
                                SizedBox(width: 8),
                                Text(
                                  'Buy Now',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
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
}

class CircleControl extends StatelessWidget {
  const CircleControl({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.foreground,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final Color color, foreground;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 36,
    height: 36,
    child: IconButton(
      tooltip: label,
      onPressed: onTap,
      style: IconButton.styleFrom(
        backgroundColor: color,
        disabledBackgroundColor: color.withValues(alpha: .6),
        foregroundColor: foreground,
        disabledForegroundColor: foreground.withValues(alpha: .5),
        padding: EdgeInsets.zero,
      ),
      icon: Icon(icon, size: 17),
    ),
  );
}

class Brand extends StatelessWidget {
  const Brand({super.key, required this.color});
  final Color color;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(
        width: 27,
        height: 27,
        child: CustomPaint(painter: BrandPainter(color)),
      ),
      const SizedBox(width: 7),
      Text(
        'xefag',
        style: TextStyle(
          fontFamily: 'Georgia',
          fontSize: 25,
          fontWeight: FontWeight.bold,
          letterSpacing: -.8,
          color: color,
        ),
      ),
    ],
  );
}

class BrandPainter extends CustomPainter {
  BrandPainter(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.width * .08
      ..style = PaintingStyle.stroke;
    for (int i = 0; i < 8; i++) {
      canvas.drawArc(
        Rect.fromLTWH(2, 2, size.width - 4, size.height - 4),
        i * math.pi / 4,
        .4,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(BrandPainter old) => old.color != color;
}

/// Layered vector packaging keeps the product artwork crisp at every size.
class Bottle extends StatelessWidget {
  const Bottle({super.key, required this.product});
  final Product product;
  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: BottlePainter(product));
}

class BottlePainter extends CustomPainter {
  BottlePainter(this.product);
  final Product product;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 160, size.height / 240);
    final sleep = product == Product.sleep;
    final body = RRect.fromRectAndRadius(
      const Rect.fromLTWH(30, 45, 100, 178),
      const Radius.circular(16),
    );
    canvas.drawOval(
      const Rect.fromLTWH(24, 213, 116, 17),
      Paint()
        ..color = Colors.black.withValues(alpha: .19)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9),
    );
    canvas.drawRRect(
      body,
      Paint()
        ..shader = LinearGradient(
          colors: sleep
              ? [
                  const Color(0xFF501B24),
                  const Color(0xFFBB5263),
                  const Color(0xFF772333),
                  const Color(0xFF491820),
                ]
              : [
                  const Color(0xFF977025),
                  const Color(0xFFF8D878),
                  const Color(0xFFDCAD37),
                  const Color(0xFF997021),
                ],
          stops: const [0, .25, .7, 1],
        ).createShader(body.outerRect),
    );
    canvas.save();
    canvas.clipRRect(body);
    final random = math.Random(17);
    for (var i = 0; i < 30; i++) {
      final x = 36 + random.nextDouble() * 83;
      final y = 167 + random.nextDouble() * 49;
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(random.nextDouble() * math.pi);
      final rect = RRect.fromRectAndRadius(
        const Rect.fromLTWH(-9, -4, 21, 9),
        const Radius.circular(5),
      );
      canvas.drawRRect(
        rect,
        Paint()
          ..shader = LinearGradient(
            colors: [
              const Color(0xFF674017),
              const Color(0xFFEDB955),
              const Color(0xFFBA7C26),
            ].map((c) => c.withValues(alpha: sleep ? .7 : .95)).toList(),
          ).createShader(rect.outerRect),
      );
      canvas.restore();
    }
    canvas.drawRect(
      const Rect.fromLTWH(30, 69, 100, 101),
      Paint()
        ..shader = LinearGradient(
          colors: sleep
              ? [
                  const Color(0xFF8B233F),
                  const Color(0xFFB44963),
                  const Color(0xFF88263D),
                ]
              : [
                  const Color(0xFFE0B938),
                  const Color(0xFFF5D864),
                  const Color(0xFFDABA44),
                ],
        ).createShader(const Rect.fromLTWH(30, 69, 100, 101)),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(35, 51, 5, 158),
        const Radius.circular(4),
      ),
      Paint()..color = Colors.white.withValues(alpha: .13),
    );
    canvas.restore();
    final cap = RRect.fromRectAndRadius(
      const Rect.fromLTWH(28, 21, 104, 31),
      const Radius.circular(3),
    );
    canvas.drawRRect(
      cap,
      Paint()
        ..shader = const LinearGradient(
          colors: [
            Color(0xFFE0E0DA),
            Color(0xFFFFFFFF),
            Color(0xFFF4F3ED),
            Color(0xFFCECEC7),
          ],
        ).createShader(cap.outerRect),
    );
    for (var i = 31.0; i < 131; i += 2) {
      canvas.drawLine(
        Offset(i, 23),
        Offset(i, 49),
        Paint()
          ..color = Colors.black.withValues(alpha: .025)
          ..strokeWidth = .5,
      );
    }
    canvas.drawLine(
      const Offset(30, 52),
      const Offset(130, 52),
      Paint()
        ..color = Colors.black.withValues(alpha: .15)
        ..strokeWidth = 2,
    );
    final fg = sleep ? const Color(0xFFFFE5E7) : const Color(0xFF4B421F);
    canvas.save();
    canvas.translate(70, 87);
    BrandPainter(fg).paint(canvas, const Size(20, 20));
    canvas.restore();
    void text(String value, double y, double fontSize, {Color? color}) {
      final tp = TextPainter(
        text: TextSpan(
          text: value,
          style: TextStyle(
            color: color ?? fg,
            fontSize: fontSize,
            fontFamily: 'Helvetica Neue',
            height: 1.15,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: 94);
      tp.paint(canvas, Offset(80 - tp.width / 2, y));
    }

    text(product.label, 111, 19);
    text('Dissolvable wafers', 136, 6);
    text('FEEL YOUR BEST', 151, 4.5);
    text('30', 191, 9, color: const Color(0xFFFFE4A7));
    canvas.restore();
  }

  @override
  bool shouldRepaint(BottlePainter old) => old.product != product;
}

class LeafPainter extends CustomPainter {
  LeafPainter({required this.color});
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = color;
    for (var i = 0; i < 5; i++) {
      canvas.save();
      canvas.translate(
        size.width * (.2 + (i % 2) * .47),
        size.height * (.2 + i * .14),
      );
      canvas.rotate(i * .8);
      final path = Path()
        ..moveTo(0, 0)
        ..quadraticBezierTo(-80, -100, 30, -120)
        ..quadraticBezierTo(90, -30, 0, 0);
      canvas.drawPath(path, p);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(LeafPainter old) => old.color != color;
}
