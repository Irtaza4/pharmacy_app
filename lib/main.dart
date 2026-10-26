import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'repositories/shop_repository.dart';
import 'theme/app_theme.dart';
import 'viewmodels/shop_view_model.dart';
import 'views/home_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: cream,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final shop = ShopViewModel(ShopRepository());
  @override
  void dispose() {
    shop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ShopScope(
    model: shop,
    child: MaterialApp(
      title: 'xefag — Your daily feel-good',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      builder: (context, child) => ColoredBox(
        color: const Color(0xFFD3E1E5),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: child,
          ),
        ),
      ),
      home: const HomeView(),
    ),
  );
}
