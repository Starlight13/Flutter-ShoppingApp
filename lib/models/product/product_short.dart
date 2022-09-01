import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
part 'product_short.g.dart';

@JsonSerializable()
class ProductShort {
  final int id;
  final String title;
  final int price;
  final String description;
  final String thumbnail;

  ProductShort({required this.id, required this.title, required this.price, required this.description, required this.thumbnail});

  String get shortDescription {
    if (description.characters.length > 50) {
      return '${description.substring(0, 50)}...';
    }
    return description;
  }

  factory ProductShort.fromJson(Map<String, dynamic> json) => _$ProductShortFromJson(json);

  static Future<ProductShort> fromId(int productId) async {
    try {
      final url = Uri.https('dummyjson.com', 'products/$productId');

      final http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        return ProductShort.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  bool operator ==(Object other) => other is ProductShort && id == other.id;

  @override
  int get hashCode => Object.hash(id.hashCode, title.hashCode);

  @override
  String toString() {
    return 'A $title for $price';
  }
}
