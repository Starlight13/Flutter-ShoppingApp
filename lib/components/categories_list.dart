import 'package:flutter/material.dart';
import 'package:shopping_app/components/calegory_row.dart';
import 'package:shopping_app/components/products_horizontal_list.dart';

import '../models/category.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
        future: Category.getAllCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                final category = snapshot.data![index];
                return CategoryRow(category: category);
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.teal,
            ),
          );
        });
  }
}
