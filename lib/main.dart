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
      create: (context) => Cart.instance,
      child: MaterialApp(
        initialRoute: ProductScreen.id,
        routes: {
          ProductScreen.id: (context) => const ProductScreen(),
          CartScreen.id: (context) => CartScreen(),
        },
      ),
    );
  }
}
