import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/components/products_list.dart';
import 'package:shopping_app/models/cart/cart.dart';

class CartScreen extends StatelessWidget {
  static const id = 'cart_screen';
  final foo = {};

  CartScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text('My cart'),
            actions: [
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Clear cart'),
                        content: const Text('Are you sure you want to clear cart?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              cart.clearCart();
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Clear cart',
                              style: TextStyle(fontWeight: FontWeight.w300),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.clear),
              ),
            ],
          ),
          body: Column(
            children: [
              ProductsList(products: cart.productsInCart),
              Text(
                'Total: ${cart.cartSummary}',
                style: const TextStyle(fontSize: 40.0),
              ),
            ],
          ),
        );
      },
    );
  }
}
