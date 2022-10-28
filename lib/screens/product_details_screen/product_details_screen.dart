import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/models/product.dart';
import 'package:shopping_app/screens/product_details_screen/components/image_carousel.dart';
import 'package:shopping_app/screens/shared_components/favourite_button.dart';
import 'package:shopping_app/screens/shared_components/item_counter.dart';
import 'package:shopping_app/screens/shared_components/cart_button.dart';
import 'package:shopping_app/screens/shared_components/primary_action_button.dart';
import 'package:shopping_app/screens/shared_components/progress_indicator.dart';
import 'package:shopping_app/viewmodels/cart_view_model.dart';
import 'package:shopping_app/viewmodels/favourites_view_model.dart';
import 'package:shopping_app/viewmodels/product_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shopping_app/viewmodels/state_view_model.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const id = 'product_details_screen';

  const ProductDetailsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = _setProductViewModel(context);
    final favViewModel = context.watch<IFavouritesViewModel>();
    final cartViewModel = context.watch<ICartViewModel>();
    final localizations = AppLocalizations.of(context)!;
    _snackBarUpdate(favViewModel, context);
    _snackBarUpdate(cartViewModel, context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.productDetails,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: const [CartButton()],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ImageCarousel(
                images: viewModel.product.images
                    .map(
                      (e) => CachedNetworkImage(
                        imageUrl: e,
                        placeholder: (context, url) =>
                            const CenteredProgressIndicator(),
                      ),
                    )
                    .toList(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 15.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        viewModel.product.title,
                        style: const TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      viewModel.product.description,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${viewModel.product.price}',
                          style: const TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 50.0,
                          width: 50.0,
                          child: FavouriteButton(
                            conditionLoading: favViewModel.isLoading,
                            conditionRed: favViewModel
                                .isProductFavourited(viewModel.product),
                            onPressed: () {
                              favViewModel.toggleFavourite(viewModel.product);
                            },
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: [
                        ItemCounter(
                          onChange: viewModel.setQuantity,
                          initialCount: 1,
                        ),
                        const SizedBox(
                          width: 30.0,
                        ),
                        Expanded(
                          child: PrimaryActionButton(
                            onTap: () {
                              cartViewModel.addToCart(
                                product: viewModel.product,
                                quantity: viewModel.quantity,
                              );
                            },
                            text: localizations.addToCart,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IProductViewModel _setProductViewModel(BuildContext context) {
    final viewModel = context.watch<IProductViewModel>();
    viewModel.setProduct(
      ModalRoute.of(context)?.settings.arguments as Product,
    );
    return viewModel;
  }

  void _snackBarUpdate(IStateViewModel viewModel, BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (viewModel.state.value == ViewModelState.success) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              viewModel.successMessage ?? localizations.operationSucces,
            ),
            backgroundColor: Colors.teal,
          ),
        );
        viewModel.resetState();
      });
    } else if (viewModel.state.value == ViewModelState.error) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              viewModel.errorMessage ?? localizations.somethingWrong,
            ),
            backgroundColor: Colors.red,
          ),
        );
        viewModel.resetState();
      });
    }
  }
}
