import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/models/cart/cart.dart';
import 'package:shopping_app/screens/cart_screen.dart';
import 'package:shopping_app/screens/products_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Cart>(
      // VR: I wouldn't recommend using singletons.
      // Let's use MVVM + Provider architecture, can discuss that on a sync.
      create: (context) => Cart.instance,
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.white,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(
              color: Colors.black.withOpacity(0.9),
            ),
          ),
        ),
        initialRoute: ProductScreen.id,
        routes: {
          ProductScreen.id: (context) => const ProductScreen(),
          CartScreen.id: (context) => CartScreen(),
        },
      ),
    );
  }
}
