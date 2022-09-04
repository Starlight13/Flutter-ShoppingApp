import 'package:flutter/material.dart';
import 'package:shopping_app/components/lists/products_horizontal_list.dart';
import 'package:shopping_app/models/category.dart';
import 'package:shopping_app/models/product/product_short.dart';
import 'package:shopping_app/extensions.dart';

class CategoryRow extends StatelessWidget {
  const CategoryRow({required this.category, Key? key}) : super(key: key);

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            category.name.capitalize(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ),
        FutureBuilder<List<ProductShort>>(
          future: category.products,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
              return ProductsHorizontalList(
                products: snapshot.data,
              );
            }
            return const SizedBox(
              height: 300,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.teal,
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
