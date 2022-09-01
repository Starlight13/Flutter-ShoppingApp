import 'package:flutter/foundation.dart';
import 'package:shopping_app/models/cart/cart_item.dart';
import 'package:shopping_app/models/product/product_short.dart';
import 'package:collection/collection.dart';

class Cart extends ChangeNotifier {
  final List<CartItem> _productsInCart = [];

  static final Cart _instance = Cart._internal();

  Cart._internal();

  static Cart get instance => _instance;

  int get productsCount => _productsInCart.length;

  int get cartSummary {
    if (productsCount != 0) {
      return _productsInCart.map((e) => e.product.price * e.quantity).reduce((a, b) => a + b);
    }
    return 0;
  }

  UnmodifiableListView<ProductShort> get productsInCart => UnmodifiableListView(_productsInCart.map((e) => e.product));

  void addToCart(CartItem newCartItem) {
    final existingCartItem = _productsInCart.firstWhereOrNull((element) => element.product == newCartItem.product);
    if (existingCartItem != null) {
      existingCartItem.increaseQty(newCartItem.quantity);
    } else {
      _productsInCart.add(newCartItem);
    }
    notifyListeners();
  }

  void clearCart() {
    _productsInCart.clear();
    notifyListeners();
  }
}
