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
        Widget child;
        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasError) {
            child = ProductsList(products: snapshot.data);
          } else {
            child = Center(
              child: Text(
                'An error occurred: ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }
        } else {
          child = const Center(
            child: CircularProgressIndicator(),
          );
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          switchInCurve: Curves.easeIn,
          child: child,
        );
      },
    );
  }
}
