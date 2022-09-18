import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/extensions.dart';
import 'package:shopping_app/screens/products_screen/components/horizontal_products_list.dart';
import 'package:shopping_app/screens/shared_components/cart_button.dart';
import 'package:shopping_app/services/locator_service.dart';
import 'package:shopping_app/viewmodels/category_view_model.dart';
import 'package:shopping_app/screens/shared_components/progress_indicator.dart';
import 'package:shopping_app/viewmodels/product_search_view_model.dart';
import 'package:sticky_headers/sticky_headers.dart';

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
        ),
        leading: IconButton(
          onPressed: () {
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
                    return StickyHeaderBuilder(
                      builder: (context, stuckAmount) {
                        return Material(
                          elevation: stuckAmount > 0 ? 0 : 10,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.only(
                              top: 20.0,
                              left: 10.0,
                              bottom: 10.0,
                            ),
                            color: Colors.white,
                            child: Text(
                              category.name.capitalize(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        );
                      },
                      content: SizedBox(
                        height: 300.0,
                        child: HorizontalProductsList(
                          category: category,
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
