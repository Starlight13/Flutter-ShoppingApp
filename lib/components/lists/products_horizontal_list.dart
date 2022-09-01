import 'package:flutter/material.dart';

import 'package:shopping_app/models/product/product_short.dart';
import 'package:shopping_app/screens/product_details_screen.dart';

const cardTextStyle = TextStyle(fontWeight: FontWeight.bold);

class ProductsHorizontalList extends StatelessWidget {
  const ProductsHorizontalList({this.products, Key? key}) : super(key: key);

  final List<ProductShort>? products;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: products?.length ?? 0,
        itemBuilder: (context, index) {
          final product = products![index];
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
                          alignment: FractionalOffset.topCenter,
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
                              style: cardTextStyle,
                            ),
                          ),
                          Text(
                            '\$${product.price}',
                            style: cardTextStyle,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      product.shortDescription,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
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
