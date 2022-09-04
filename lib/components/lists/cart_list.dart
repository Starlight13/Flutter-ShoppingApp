import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/components/lists/items/cart_row.dart';

import '../../models/cart/cart.dart';

class CartList extends StatelessWidget {
  const CartList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartItems = context.watch<Cart>().productsInCart;
    if (cartItems.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          return CartRow(item: cartItems[index]);
        },
      );
    }
    return const Center(
      child: Text('Could not find products to show'),
    );
  }
}
