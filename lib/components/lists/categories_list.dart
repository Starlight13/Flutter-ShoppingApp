import 'package:flutter/material.dart';
import 'package:shopping_app/components/lists/items/category_row.dart';
import 'package:shopping_app/models/category.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: Category.getAllCategories(),
      builder: (context, snapshot) {
        Widget child;
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          child = ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              final category = snapshot.data![index];
              return CategoryRow(category: category);
            },
          );
        } else {
          child = const Center(
            child: CircularProgressIndicator(
              color: Colors.teal,
            ),
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
