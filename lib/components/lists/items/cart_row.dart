import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/components/item_counter.dart';
import 'package:shopping_app/models/cart/cart.dart';
import 'package:shopping_app/models/cart/cart_item.dart';

import '../../../constants.dart';

class CartRow extends StatelessWidget {
  final CartItem item;
  const CartRow({required this.item, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // VR: fix this warning, unnecessary check
    if (item != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Slidable(
          key: ValueKey(item.product.id),
          startActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: 0.2,
            dismissible: DismissiblePane(
              dismissThreshold: 0.9,
              onDismissed: () {
                context.read<Cart>().removeItemFromCart(item);
              },
            ),
            openThreshold: 0.1,
            closeThreshold: 0.1,
            children: [
              SlidableAction(
                padding: EdgeInsets.zero,
                spacing: 0,
                onPressed: (_) {},
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.red.withOpacity(0.8),
                icon: Icons.delete,
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(
                height: 120,
                width: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Image.network(
                    item.product.thumbnail,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      item.product.shortDescription,
                      style: descriptionTextStyle,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${item.product.price}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        ItemCounter(
                          size: 20.0,
                          onChange: (newQty) {
                            context.read<Cart>().changeItemQty(item, newQty);
                          },
                          initialCount: item.quantity,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Container();
  }
}
