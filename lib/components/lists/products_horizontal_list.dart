import 'package:flutter/material.dart';
import 'package:shopping_app/constants.dart';

import 'package:shopping_app/models/product/product_short.dart';
import 'package:shopping_app/screens/product_details_screen.dart';

class ProductsHorizontalList extends StatefulWidget {
  const ProductsHorizontalList({this.products, Key? key}) : super(key: key);
  final List<ProductShort>? products;

  @override
  State<ProductsHorizontalList> createState() => _ProductsHorizontalListState();
}

class _ProductsHorizontalListState extends State<ProductsHorizontalList> {
  double horizontalOffset = 0.0;

  late final ScrollController _scrollController = ScrollController()
    ..addListener(() {
      setState(() {
        horizontalOffset = _scrollController.position.pixels /
            _scrollController.position.viewportDimension;
      });
    });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320.0,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: widget.products?.length ?? 0,
        itemBuilder: (context, index) {
          final product = widget.products![index];
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsScreen(
                      productId: product.id,
                    ),
                  ),
                );
              },
              child: SizedBox(
                width: 200,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: SizedBox(
                        height: 200,
                        width: 200,
                        child: Image.network(
                          product.thumbnail,
                          alignment: Alignment(
                            (horizontalOffset - index * 0.5),
                            0,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              product.title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            '\$${product.price}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
    );
  }
}
