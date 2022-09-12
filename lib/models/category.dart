import 'package:shopping_app/models/product.dart';

class Category {
  final String name;
  final List<Product> products;

  Category({
    required this.name,
  }) : products = [];
}
