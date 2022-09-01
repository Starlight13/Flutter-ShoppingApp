import 'package:flutter/material.dart';
import 'package:shopping_app/screens/product_details_screen.dart';
import 'package:shopping_app/models/product/product_short.dart';

class ProductListTile extends StatelessWidget {
  const ProductListTile({
    required this.product,
    Key? key,
  }) : super(key: key);

  final ProductShort? product;

  @override
  Widget build(BuildContext context) {
    if (product != null) {
      return ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(
                productId: product!.id,
              ),
            ),
          );
        },
        title: Text(product!.title),
        trailing: Text('${product!.price}'),
      );
    }
    return Container();
  }
}
