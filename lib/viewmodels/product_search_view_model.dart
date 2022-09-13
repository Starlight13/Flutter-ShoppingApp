import 'package:flutter/material.dart';
import 'package:shopping_app/repositories/products_repo.dart';
import 'package:shopping_app/screens/shared_components/product_search_builder.dart';

class ProductSearchViewModel extends SearchDelegate {
  final IProductsRepo _productsRepo;

  ProductSearchViewModel({required IProductsRepo productsRepo})
      : _productsRepo = productsRepo;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ProductSearchBuilder(
      future: _productsRepo.searchProducts(query: query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ProductSearchBuilder(
      future: _productsRepo.searchProducts(query: query),
    );
  }
}
