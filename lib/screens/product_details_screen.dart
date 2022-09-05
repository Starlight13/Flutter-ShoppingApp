import 'package:flutter/material.dart';
import 'package:shopping_app/components/add_to_cart_toolbar.dart';
import 'package:shopping_app/components/buttons/cart_button.dart';
import 'package:shopping_app/components/image_carousel.dart';
import 'package:shopping_app/constants.dart';
import 'package:shopping_app/models/product/product.dart';
import 'package:shopping_app/models/product/product_short.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const id = 'product_details_screen';

  final int productId;

  const ProductDetailsScreen({required this.productId, Key? key})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );

  @override
  void initState() {
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        actions: [
          CartButton(
            controller: _controller,
          )
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<Product>(
          future: Product.productFromId(widget.productId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final product = snapshot.data!;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      ImageCarousel(
                        images: product.images
                            .map(
                              (e) => Image.network(e),
                            )
                            .toList(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: Text(
                                product.title,
                                style: const TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              product.description,
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              '\$${product.price}',
                              style: const TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            AddToCartToolbar(
                              additionalAction: () {
                                _controller.forward();
                              },
                              // VR: instead of 5 params we can pass only one: product
                              product: ProductShort(
                                id: product.id,
                                title: product.title,
                                price: product.price,
                                description: product.description,
                                thumbnail: product.thumbnail,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: Text('Something went wrong'),
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
