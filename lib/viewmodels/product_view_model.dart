import 'package:flutter/material.dart';
import 'package:shopping_app/models/product.dart';

abstract class IProductViewModel with ChangeNotifier {
  Product get product;

  int get quantity;

  void setProduct(Product product);

  void setQuantity(int qty);
}

class ProductViewModel with ChangeNotifier implements IProductViewModel {
  late Product _product;
  late int _quantity = 1;

  @override
  Product get product => _product;

  @override
  int get quantity => _quantity;

  @override
  void setProduct(Product product) => _product = product;

  @override
  void setQuantity(int qty) => _quantity = qty;
}
