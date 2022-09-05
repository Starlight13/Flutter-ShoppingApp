import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shopping_app/models/product/product_short.dart';

class Category {
  final String _name;

  Category._internal(this._name);

  String get name => _name;

  Future<List<ProductShort>> get products async {
    try {
      // VR: it's too messy to mix Network service with a models. Will cover it with MVVM
      final url = Uri.https('dummyjson.com', 'products/category/$name');

      final http.Response response = await http.get(url);
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

  static Future<List<Category>> getAllCategories() async {
    try {
      final url = Uri.https('dummyjson.com', 'products/categories');

      final http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as List;
        return data.map((e) => Category._internal(e)).toList();
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
