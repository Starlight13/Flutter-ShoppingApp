import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shopping_app/components/product_future_builder.dart';
import 'package:shopping_app/components/product_search.dart';
import 'package:shopping_app/models/cart/cart.dart';
import 'package:shopping_app/models/category.dart';
import 'package:shopping_app/models/product/product_short.dart';
import 'package:shopping_app/components/cart_button.dart';

import '../components/categories_list.dart';

class ProductScreen extends StatefulWidget {
  static const id = 'product_screen';

  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<ProductShort>? products;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<List<ProductShort>> getData() async {
    try {
      var url = Uri.https('dummyjson.com', 'products');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['products'] as List;
        return data.map((e) => ProductShort.fromJson(e)).toList();
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Shopping app'),
            leading: IconButton(
              onPressed: () {
                showSearch(context: context, delegate: ProductSearchDelegate());
              },
              icon: const Icon(Icons.search),
            ),
            actions: const [CartButton()],
          ),
          body: const SafeArea(
            child: Padding(padding: EdgeInsets.only(top: 20.0), child: CategoriesList()),
          ),
        );
      },
    );
  }
}
