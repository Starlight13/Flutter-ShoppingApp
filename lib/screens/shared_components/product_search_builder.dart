import 'package:flutter/material.dart';
import 'package:shopping_app/models/circle_transition_arguments.dart';
import 'package:shopping_app/models/product.dart';
import 'package:shopping_app/screens/product_details_screen.dart/product_details_screen.dart';
import 'package:shopping_app/screens/shared_components/progress_indicator.dart';

class ProductSearchBuilder extends StatelessWidget {
  final Future<List<Product>> _future;
  const ProductSearchBuilder({
    required Future<List<Product>> future,
    Key? key,
  })  : _future = future,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints) => FutureBuilder<List<Product>>(
            future: _future,
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return snapshot.data!.isEmpty
                    ? const Center(child: Text('No matching products'))
                    : ListView.builder(
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: ((context, index) {
                          final product = snapshot.data![index];
                          return ListTile(
                            title: Text(product.title),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                ProductDetailsScreen.id,
                                // arguments: product.id,
                                arguments: CircleTransitionArguments(
                                  product: product,
                                  circleStartCenter: Offset(
                                    constraints.maxWidth / 2,
                                    constraints.maxHeight / 2,
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      );
              } else {
                return const CenteredProgressIndicator();
              }
            }),
          )),
    );
  }
}
