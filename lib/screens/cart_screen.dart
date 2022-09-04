import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/components/lists/cart_list.dart';
import 'package:shopping_app/constants.dart';
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
            title: const Text(
              'My cart',
              style: appBarTitleStyle,
            ),
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
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const CartList(),
                Divider(
                  thickness: 2.0,
                  color: Colors.grey.withOpacity(0.1),
                ),
                Row(
                  children: [
                    const Text(
                      'Total:',
                      style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.grey),
                    ),
                    Expanded(
                      child: Text(
                        '\$${cart.cartSummary}',
                        textAlign: TextAlign.end,
                        style: const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.teal),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
