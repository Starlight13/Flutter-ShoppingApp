import 'package:flutter/foundation.dart';
import 'package:shopping_app/models/cart_item.dart';
import 'package:shopping_app/models/product.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

abstract class ICartViewModel with ChangeNotifier {
  int get productsCount;

  int get cartSummary;

  UnmodifiableListView<CartItem> get productsInCart;

  void removeItemFromCart({
    required CartItem cartItem,
  });

  void changeItemQty({
    required CartItem cartItem,
    required int newQty,
  });

  CartItem? findCartItem({
    required Product product,
  });

  void addToCart({
    required Product product,
    required int quantity,
  });

  void increaseQtyOfProduct({
    required CartItem cartItem,
    required int by,
  });

  void clearCart();
}

class CartViewModel with ChangeNotifier implements ICartViewModel {
  final List<CartItem> _productsInCart = [];

  @override
  int get productsCount => _productsInCart.length;

  @override
  int get cartSummary {
    if (productsCount != 0) {
      return _productsInCart
          .map((e) => e.product.price * e.quantity)
          .reduce((a, b) => a + b);
    }
    return 0;
  }

  @override
  UnmodifiableListView<CartItem> get productsInCart =>
      UnmodifiableListView(_productsInCart);

  @override
  void removeItemFromCart({
    required CartItem cartItem,
  }) {
    _productsInCart.remove(cartItem);
    notifyListeners();
  }

  @override
  void changeItemQty({
    required CartItem cartItem,
    required int newQty,
  }) {
    final item = findCartItem(product: cartItem.product);
    if (item != null) {
      item.quantity = newQty;
      notifyListeners();
    }
  }

  @override
  CartItem? findCartItem({
    required Product product,
  }) {
    return _productsInCart
        .firstWhereOrNull((element) => element.product == product);
  }

  @override
  void addToCart({
    required Product product,
    required int quantity,
  }) {
    final existingCartItem = findCartItem(product: product);
    if (existingCartItem != null) {
      increaseQtyOfProduct(
        by: quantity,
        cartItem: existingCartItem,
      );
    } else {
      _productsInCart.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  @override
  void increaseQtyOfProduct({
    required CartItem cartItem,
    required int by,
  }) {
    if (by > 0) {
      cartItem.quantity += by;
    }
  }

  @override
  void clearCart() {
    _productsInCart.clear();
    notifyListeners();
  }
}
