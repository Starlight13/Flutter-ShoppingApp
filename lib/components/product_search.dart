import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_app/components/product_future_builder.dart';
import 'package:http/http.dart' as http;

import 'package:shopping_app/models/product/product_short.dart';

class ProductSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ProductFutureBuilder(
      future: getSearchData(query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ProductFutureBuilder(
      future: getSearchData(query),
    );
  }

  Future<List<ProductShort>> getSearchData(String query) async {
    try {
      final queryParams = {
        'q': query,
      };
      var url = Uri.https('dummyjson.com', 'products/search', queryParams);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['products'] as List;
        return data.map((e) => ProductShort.fromJson(e)).toList();
      }
    } catch (e) {
      throw Exception(e);
    }
    throw Exception('Something went wrong');
  }
}
