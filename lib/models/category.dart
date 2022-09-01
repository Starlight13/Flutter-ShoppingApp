import 'dart:convert';

import 'package:shopping_app/models/product/product_short.dart';
import 'package:http/http.dart' as http;

class Category {
  String name;
  List<ProductShort>? products;

  Category(this.name) {
    getProductsInCategory();
  }

  void getProductsInCategory() async {
    try {
      final url = Uri.https('dummyjson.com', 'products/category/$name');

      final http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['products'] as List;
        products = data.map((e) => ProductShort.fromJson(e)).toList();
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
