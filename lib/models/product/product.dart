import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
part 'product.g.dart';

@JsonSerializable()
class Product {
  final int id;
  final String title;
  final String description;
  final int price;
  final String thumbnail;
  final List<String> images;

  Product(this.id, this.title, this.description, this.price, this.images, this.thumbnail);

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  @override
  String toString() {
    return 'A $title for $price';
  }

  static Future<Product> productFromId(int productId) async {
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
  bool operator ==(Object other) => other is Product && id == other.id;

  @override
  int get hashCode => Object.hash(id.hashCode, title.hashCode);
}
