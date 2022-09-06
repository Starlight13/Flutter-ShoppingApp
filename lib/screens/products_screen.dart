import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/components/product_search.dart';
import 'package:shopping_app/constants.dart';
import 'package:shopping_app/models/cart/cart.dart';
import 'package:shopping_app/components/buttons/cart_button.dart';
import 'package:shopping_app/components/lists/categories_list.dart';

class ProductScreen extends StatelessWidget {
  static const id = 'product_screen';

  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Shopping app',
              style: appBarTitleStyle,
            ),
            leading: IconButton(
              onPressed: () {
                showSearch(context: context, delegate: ProductSearch());
              },
              icon: const Icon(Icons.search),
            ),
            actions: [CartButton()],
          ),
          body: const SafeArea(
            child: CategoriesList(),
          ),
        );
      },
    );
  }
}
