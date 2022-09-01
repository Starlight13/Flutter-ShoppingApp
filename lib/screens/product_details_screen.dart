import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shopping_app/components/big_button.dart';
import 'package:shopping_app/models/cart/cart.dart';
import 'package:shopping_app/models/product/product.dart';
import 'package:shopping_app/models/product/product_short.dart';
import 'package:shopping_app/components/cart_button.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const id = 'product_details_screen';

  final int productId;
  final String productTitle;

  const ProductDetailsScreen({required this.productId, required this.productTitle, Key? key}) : super(key: key);

  Future<Product> getProductData() async {
    try {
      final url = Uri.https('dummyjson.com', 'products/$productId');

      final http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        return Product.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: const [CartButton()],
      ),
      body: SafeArea(
        child: FutureBuilder<Product>(
          future: getProductData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final product = snapshot.data!;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      CarouselSlider(
                        items: product.images
                            .map(
                              (e) => Image.network(
                                e,
                                fit: BoxFit.fitWidth,
                              ),
                            )
                            .toList(),
                        options: CarouselOptions(
                          pageSnapping: true,
                          viewportFraction: 1.0,
                          enlargeCenterPage: true,
                          enlargeStrategy: CenterPageEnlargeStrategy.height,
                          aspectRatio: 1.0,
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              product.description,
                              style: const TextStyle(
                                fontSize: 30.0,
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            const Text(
                              'Only for',
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                            Text(
                              '\$${product.price}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 40.0,
                              ),
                            ),
                            BigButton(
                              'Add to cart',
                              onPressed: () {
                                context.read<Cart>().addToCart(
                                      ProductShort(
                                        id: product.id,
                                        title: product.title,
                                        price: product.price,
                                        description: product.description,
                                        thumbnail: product.thumbnail,
                                      ),
                                    );
                                Navigator.pop(context);
                              },
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
