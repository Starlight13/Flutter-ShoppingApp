import 'package:shopping_app/models/product/product_short.dart';

class CartItem {
  int _quantity;
  final ProductShort _product;

  CartItem(this._quantity, this._product);

  ProductShort get product => _product;
  int get quantity => _quantity;

  @override
  bool operator ==(other) => other is CartItem && other.product.id == product.id;

  @override
  int get hashCode => Object.hash(quantity.hashCode, product.hashCode);

  void increaseQty(int by) {
    _quantity += by;
  }

  void decreaseQty() {
    _quantity--;
  }
}
