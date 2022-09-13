import 'package:flutter/material.dart';
import 'package:shopping_app/models/product.dart';
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
    return FutureBuilder<List<Product>>(
      future: _future,
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return snapshot.data!.isEmpty
              ? const Center(child: Text('No matching products'))
              : ListView.builder(
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: ((context, index) {
                    return ListTile(
                      title: Text(snapshot.data![index].title),
                    );
                  }),
                );
        } else {
          return const CenteredProgressIndicator();
        }
      }),
    );
  }
}
