import 'package:flutter/material.dart';
import 'package:shopping_app/components/lists/products_list.dart';

import 'package:shopping_app/models/product/product_short.dart';

class ProductFutureBuilder extends StatelessWidget {
  const ProductFutureBuilder({
    required this.future,
    Key? key,
  }) : super(key: key);

  final Future<List<ProductShort>> future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductShort>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasError) {
            return ProductsList(products: snapshot.data);
          } else {
            return Center(
              child: Text(
                'An error occurred: ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
