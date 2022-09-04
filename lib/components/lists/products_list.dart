import 'package:flutter/material.dart';
import 'package:shopping_app/components/lists/items/product_list_tile.dart';
import 'package:shopping_app/models/product/product_short.dart';

class ProductsList extends StatelessWidget {
  const ProductsList({
    required this.products,
    Key? key,
  }) : super(key: key);

  final List<ProductShort>? products;

  @override
  Widget build(BuildContext context) {
    if (products?.isNotEmpty ?? false) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: products?.length ?? 0,
        itemBuilder: (context, index) {
          final product = products![index];
          return ProductListTile(product: product);
        },
      );
    }
    return const Center(
      child: Text('Could not find products to show'),
    );
  }
}
