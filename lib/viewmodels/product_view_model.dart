import 'package:flutter/material.dart';
import 'package:shopping_app/models/product.dart';
import 'package:shopping_app/services/locator_service.dart';
import 'package:shopping_app/viewmodels/category_view_model.dart';

abstract class IProductViewModel with ChangeNotifier {
  Product get product;

  int get quantity;

  void setProduct(Product product);

  void setQuantity(int qty);

  void setProductWithId({required int id});
}

class ProductViewModel with ChangeNotifier implements IProductViewModel {
  late Product _product;
  late int _quantity;

  @override
  Product get product => _product;

  @override
  int get quantity => _quantity;

  @override
  void setProduct(Product product) => _product = product;

  @override
  void setQuantity(int qty) => _quantity = qty;

  @override
  void setProductWithId({required int id}) {
    setProduct(sl.get<ICategoryViewModel>().findById(id));
    setQuantity(1);
  }
}
