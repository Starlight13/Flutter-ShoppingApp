import 'package:shopping_app/models/product/product_short.dart';

class CartItem {
  int quantity;
  final ProductShort _product;

  CartItem(this.quantity, this._product);

  ProductShort get product => _product;

  @override
  bool operator ==(other) => other is CartItem && other.product.id == product.id;

  @override
  int get hashCode => Object.hash(quantity.hashCode, product.hashCode);

  void increaseQty(int by) {
    quantity += by;
  }

  void decreaseQty() {
    quantity--;
  }
}
