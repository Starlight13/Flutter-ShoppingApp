import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:shopping_app/models/cart/cart_item.dart';

// VR: hmm, Cart is actually not a model as it contains a lot of logic
class Cart extends ChangeNotifier {
  final List<CartItem> _productsInCart = [];

  static final Cart _instance = Cart._internal();

  Cart._internal();

  static Cart get instance => _instance;

  int get productsCount => _productsInCart.length;

  int get cartSummary {
    if (productsCount != 0) {
      // VR: good job!!! (with using functional approach here)
      return _productsInCart
          .map((e) => e.product.price * e.quantity)
          .reduce((a, b) => a + b);
    }
    return 0;
  }

  UnmodifiableListView<CartItem> get productsInCart =>
      UnmodifiableListView(_productsInCart);

  void removeItemFromCart(CartItem cartItem) {
    _productsInCart.remove(cartItem);
    notifyListeners();
  }

  void changeItemQty(CartItem cartItem, int newQty) {
    final item = findCartItem(cartItem);
    if (item != null) {
      item.quantity = newQty;
      notifyListeners();
    }
  }

  CartItem? findCartItem(CartItem cartItem) {
    return _productsInCart
        .firstWhereOrNull((element) => element.product == cartItem.product);
  }

  void addToCart(CartItem newCartItem) {
    final existingCartItem = findCartItem(newCartItem);
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
