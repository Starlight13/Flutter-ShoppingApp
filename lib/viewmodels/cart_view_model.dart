import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:shopping_app/models/cart_item.dart';
import 'package:shopping_app/models/product.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:shopping_app/viewmodels/state_view_model.dart';

abstract class ICartViewModel extends IStateViewModel {
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

class CartViewModel extends ICartViewModel {
  final List<CartItem> _productsInCart = [];
  String? _successMessage;
  final ValueNotifier<ViewModelState> _state =
      ValueNotifier(ViewModelState.idle);
  RestartableTimer? _timer;

  @override
  int get productsCount => _productsInCart.length;

  @override
  String? get errorMessage => null;

  @override
  ValueNotifier<ViewModelState> get state => _state;

  @override
  String? get successMessage => _successMessage;

  @override
  void resetState() {
    if (_timer == null) {
      _timer = RestartableTimer(const Duration(milliseconds: 1000), () {
        _setSuccessMessage(null);
        _setState(ViewModelState.idle);
      });
    } else {
      _timer!.reset();
    }
  }

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
    _setSuccessMessage('You have removed ${cartItem.product.title} from cart');
    _setState(ViewModelState.success);
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
    _setSuccessMessage('You have added ${product.title} to cart');
    _setState(ViewModelState.success);
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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _setState(ViewModelState newState) async {
    _state.value = newState;
    _state.notifyListeners();
    notifyListeners();
  }

  void _setSuccessMessage(String? sucessMessage) {
    _successMessage = sucessMessage;
    notifyListeners();
  }
}
