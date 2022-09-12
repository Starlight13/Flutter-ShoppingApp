import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/constants.dart';
import 'package:shopping_app/screens/product_details_screen.dart/components/image_carousel.dart';
import 'package:shopping_app/screens/shared_components/item_counter.dart';
import 'package:shopping_app/screens/shared_components/cart_button.dart';
import 'package:shopping_app/viewmodels/cart_view_model.dart';
import 'package:shopping_app/viewmodels/category_view_model.dart';
import 'package:shopping_app/viewmodels/product_view_model.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const id = 'product_details_screen';

  const ProductDetailsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = _setProductViewModel(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product Details',
          style: appBarTitleStyle,
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
                      (e) => Image.network(e),
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
                    Text(
                      '\$${viewModel.product.price}',
                      style: const TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
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
                          child: GestureDetector(
                            onTap: () {
                              final cartViewModel =
                                  context.read<ICartViewModel>();
                              cartViewModel.addToCart(
                                product: viewModel.product,
                                quantity: viewModel.quantity,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${viewModel.product.title} added to cart!',
                                  ),
                                  backgroundColor: Colors.teal,
                                ),
                              );
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.teal,
                              ),
                              child: const Text(
                                'Add to cart',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
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
    final productId = ModalRoute.of(context)?.settings.arguments as int;
    final currentProduct =
        context.read<ICategoryViewModel>().findById(productId);
    viewModel.setProduct(currentProduct);
    viewModel.setQuantity(1);
    return viewModel;
  }
}