import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/models/cart/cart_item.dart';

import 'package:shopping_app/models/product/product_short.dart';
import 'package:shopping_app/components/buttons/big_button.dart';
import 'package:shopping_app/models/cart/cart.dart';
import 'package:shopping_app/components/buttons/square_button.dart';

class AddToCartToolbar extends StatefulWidget {
  const AddToCartToolbar({
    required this.product,
    Key? key,
  }) : super(key: key);

  final ProductShort product;

  @override
  State<AddToCartToolbar> createState() => _AddToCartToolbarState();
}

class _AddToCartToolbarState extends State<AddToCartToolbar> {
  int qty = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SquareButton(
          onPressed: () {
            setState(() {
              if (qty - 1 > 0) {
                qty--;
              }
            });
          },
          buttonColor: Colors.white,
          child: const Icon(
            Icons.remove,
            color: Colors.teal,
          ),
        ),
        SizedBox(
          width: 50.0,
          child: Text(
            '$qty',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
        ),
        SquareButton(
          onPressed: () {
            setState(() {
              qty += 1;
            });
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          width: 30.0,
        ),
        Expanded(
          child: BigButton(
            'Add to cart',
            onPressed: () {
              context.read<Cart>().addToCart(CartItem(qty, widget.product));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${widget.product.title} added to cart!'),
                  backgroundColor: Colors.teal,
                ),
              );
              setState(() {
                qty = 1;
                Navigator.pop(context);
              });
            },
          ),
        ),
      ],
    );
  }
}
