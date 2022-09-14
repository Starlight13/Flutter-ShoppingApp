import 'package:shopping_app/models/product.dart';

class CartItem {
  Product product;
  int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });

  @override
  bool operator ==(other) =>
      other is CartItem && other.product.id == product.id;

  @override
  int get hashCode => Object.hash(quantity.hashCode, product.hashCode);
}
