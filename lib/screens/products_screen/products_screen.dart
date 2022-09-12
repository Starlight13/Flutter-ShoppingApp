import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/extensions.dart';
import 'package:shopping_app/screens/product_details_screen.dart/product_details_screen.dart';
import 'package:shopping_app/screens/shared_components/cart_button.dart';

import 'package:shopping_app/constants.dart';
import 'package:shopping_app/services/locator_service.dart';

import 'package:shopping_app/viewmodels/category_view_model.dart';
import 'package:shopping_app/screens/shared_components/progress_indicator.dart';
import 'package:shopping_app/viewmodels/product_search_view_model.dart';

class ProductsScreen extends StatelessWidget {
  static String id = 'productsScreen';

  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ICategoryViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shopping app',
          style: appBarTitleStyle,
        ),
        leading: IconButton(
          onPressed: () {
            //TODO: Show search
            showSearch(
              context: context,
              delegate: ProductSearchViewModel(productsRepo: sl.get()),
            );
          },
          icon: const Icon(Icons.search),
        ),
        actions: const [CartButton()],
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(seconds: 1),
          child: viewModel.isLoading
              ? const CenteredProgressIndicator()
              : ListView.builder(
                  itemCount: viewModel.categoriesCount,
                  itemBuilder: (context, index) {
                    final category = viewModel.categories[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 10.0),
                          child: Text(
                            category.name.capitalize(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 320.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: category.products.length,
                            itemBuilder: (context, index) {
                              final product = category.products[index];
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    viewModel.setSelectedCategory(category);
                                    Navigator.pushNamed(
                                      context,
                                      ProductDetailsScreen.id,
                                      arguments: product.id,
                                    );
                                  },
                                  child: SizedBox(
                                    width: 200,
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: SizedBox(
                                            height: 200,
                                            width: 200,
                                            child: Image.network(
                                              product.thumbnail,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 10.0,
                                            bottom: 5.0,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  product.title,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                '\$${product.price}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          product.shortDescription,
                                          style: descriptionTextStyle,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    );
                  },
                ),
        ),
      ),
    );
  }
}
