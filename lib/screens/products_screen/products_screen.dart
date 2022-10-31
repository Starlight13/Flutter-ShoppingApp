import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/extensions.dart';
import 'package:shopping_app/screens/auth_screen/auth_screen.dart';
import 'package:shopping_app/screens/favourites_screen/favourites_screen.dart';
import 'package:shopping_app/screens/products_screen/components/drawer_item.dart';
import 'package:shopping_app/screens/products_screen/components/horizontal_products_list.dart';
import 'package:shopping_app/screens/shared_components/cart_button.dart';
import 'package:shopping_app/screens/shared_components/status_snack_bar.dart';
import 'package:shopping_app/services/locator_service.dart';
import 'package:shopping_app/viewmodels/auth_view_model.dart';
import 'package:shopping_app/viewmodels/category_view_model.dart';
import 'package:shopping_app/screens/shared_components/progress_indicator.dart';
import 'package:shopping_app/viewmodels/product_search_view_model.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductsScreen extends StatelessWidget {
  static String id = 'productsScreen';

  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ICategoryViewModel>();
    final localizations = AppLocalizations.of(context)!;
    final authViewModel = context.watch<IAuthViewModel>();
    return StatusSnackBar(
      viewModel: authViewModel,
      child: Scaffold(
        drawer: Drawer(
          backgroundColor: Colors.teal,
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        showSearch(
                          context: context,
                          delegate:
                              ProductSearchViewModel(productsRepo: sl.get()),
                        );
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: ((child, animation) {
                    return SizeTransition(
                      sizeFactor: animation,
                      axis: Axis.vertical,
                      axisAlignment: -1,
                      child: Center(child: child),
                    );
                  }),
                  child: authViewModel.isLoggedIn &&
                          authViewModel.currentUser != null
                      ? Column(
                          children: [
                            if (authViewModel.photoUrl != null)
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                foregroundImage: NetworkImage(
                                  authViewModel.photoUrl!,
                                ),
                                radius: 50.0,
                              )
                            else
                              Column(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.orange,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(30.0),
                                    width: 130.0,
                                    child: Center(
                                      child: Text(
                                        authViewModel.currentUser!.displayName
                                                ?.substring(0, 1) ??
                                            authViewModel.currentUser!.email!
                                                .substring(0, 1),
                                        style: const TextStyle(
                                          fontSize: 30.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            Text(
                              authViewModel.currentUser!.displayName ??
                                  authViewModel.currentUser!.email!,
                              style: const TextStyle(
                                fontSize: 25.0,
                                color: Colors.white,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            DrawerItem(
                              onTap: () => Navigator.pushNamed(
                                context,
                                FavouritesScreen.id,
                              ),
                              title: localizations.favourites,
                            ),
                            DrawerItem(
                              title: localizations.logOut,
                              onTap: () => authViewModel.logOut(),
                            ),
                          ],
                        )
                      : GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, AuthScreen.id);
                          },
                          child: Text(
                            localizations.logIn,
                            style: const TextStyle(
                              fontSize: 25.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                )
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: const Text(
            'Shopping app',
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
                      late final productFuture =
                          viewModel.fetchProductsForCategory(category);
                      return StickyHeaderBuilder(
                        builder: (context, stuckAmount) {
                          return Material(
                            elevation: stuckAmount >= 0 ? 0 : 10,
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
                          child: FutureBuilder(
                            future: productFuture,
                            builder: ((context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return HorizontalProductsList(
                                  category: category,
                                );
                              } else {
                                return const CenteredProgressIndicator();
                              }
                            }),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
