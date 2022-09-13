import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/screens/cart_screen/cart_screen.dart';
import 'package:shopping_app/screens/products_screen/products_screen.dart';
import 'package:shopping_app/services/locator_service.dart';
import 'package:shopping_app/viewmodels/cart_view_model.dart';
import 'package:shopping_app/viewmodels/category_view_model.dart';
import 'package:shopping_app/viewmodels/product_view_model.dart';

import 'package:shopping_app/screens/product_details_screen.dart/product_details_screen.dart';

void main() {
  setupLocator();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ICartViewModel>(
          create: (_) => CartViewModel(),
        ),
        ChangeNotifierProvider<ICategoryViewModel>(
          create: (_) => CategoryViewModel(
            categoryRepo: sl.get(),
            productsRepo: sl.get(),
          ),
        ),
        ChangeNotifierProvider<IProductViewModel>(
          create: (_) => ProductViewModel(),
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
      initialRoute: ProductsScreen.id,
      routes: {
        ProductsScreen.id: (context) => const ProductsScreen(),
        ProductDetailsScreen.id: (context) => const ProductDetailsScreen(),
        CartScreen.id: ((context) => const CartScreen()),
      },
    );
  }
}
