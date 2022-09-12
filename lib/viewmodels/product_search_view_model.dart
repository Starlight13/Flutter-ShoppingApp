import 'package:flutter/material.dart';
import 'package:shopping_app/models/product.dart';
import 'package:shopping_app/repositories/products_repo.dart';

class ProductSearchViewModel extends SearchDelegate with ChangeNotifier {
  final IProductsRepo _productsRepo;
  List<Product> foundProducts = [];

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
    getSearchData(query);
    return ListView.builder(
      itemCount: foundProducts.length,
      itemBuilder: ((context, index) => ListTile(
            title: Text(foundProducts[index].title),
          )),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  void getSearchData(String query) async {
    foundProducts = await _productsRepo.searchProducts(query: query);
  }
}
