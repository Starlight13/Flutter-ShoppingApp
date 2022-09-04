import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/components/item_counter.dart';
import 'package:shopping_app/models/cart/cart_item.dart';

import 'package:shopping_app/models/product/product_short.dart';
import 'package:shopping_app/components/buttons/big_button.dart';
import 'package:shopping_app/models/cart/cart.dart';

class AddToCartToolbar extends StatelessWidget {
  AddToCartToolbar({
    required this.product,
    this.additionalAction,
    Key? key,
  }) : super(key: key);

  final ProductShort product;
  final Function()? additionalAction;
  int qty = 1;

  void updateQty(int newQty) {
    qty = newQty;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ItemCounter(
          onChange: updateQty,
          initialCount: 1,
        ),
        const SizedBox(
          width: 30.0,
        ),
        Expanded(
          child: BigButton(
            'Add to cart',
            onPressed: () {
              context.read<Cart>().addToCart(CartItem(qty, product));
              if (additionalAction != null) {
                additionalAction!();
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.title} added to cart!'),
                  backgroundColor: Colors.teal,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
