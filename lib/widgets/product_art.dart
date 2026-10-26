import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/product.dart';

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
          fontFamily: 'DMSerifDisplay',
          fontSize: 25,
          fontWeight: FontWeight.w400,
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
          colors: [
            Color.lerp(product.color, Colors.black, .55)!,
            Color.lerp(product.color, Colors.white, .28)!,
            product.color,
            Color.lerp(product.color, Colors.black, .5)!,
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
          colors: [
            Color.lerp(product.color, Colors.black, .1)!,
            Color.lerp(product.color, Colors.white, .18)!,
            product.color,
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
    final fg = product.isDark ? Colors.white : const Color(0xFF303B29);
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
            fontFamily: 'Manrope',
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
    canvas.clipRect(Offset.zero & size);
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
