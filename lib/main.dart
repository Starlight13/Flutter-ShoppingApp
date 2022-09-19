import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/screens/cart_screen/cart_screen.dart';
import 'package:shopping_app/screens/products_screen/products_screen.dart';
import 'package:shopping_app/screens/splash_screen/splash_screen.dart';
import 'package:shopping_app/services/locator_service.dart';
import 'package:shopping_app/viewmodels/cart_view_model.dart';
import 'package:shopping_app/viewmodels/category_view_model.dart';
import 'package:shopping_app/viewmodels/product_view_model.dart';
import 'package:shopping_app/screens/product_details_screen.dart/product_details_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  setupLocator();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ICartViewModel>(
          create: (_) => sl.get(),
        ),
        ChangeNotifierProvider<ICategoryViewModel>(
          create: (_) => sl.get(),
        ),
        ChangeNotifierProvider<IProductViewModel>(
          create: (_) => sl.get(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        primaryColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          titleTextStyle: const TextStyle(
            fontSize: 20.0,
            color: Colors.black,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black.withOpacity(0.9),
          ),
        ),
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        ProductsScreen.id: (context) => const ProductsScreen(),
        ProductDetailsScreen.id: (context) => const ProductDetailsScreen(),
        CartScreen.id: ((context) => const CartScreen()),
      },
    );
  }
}
