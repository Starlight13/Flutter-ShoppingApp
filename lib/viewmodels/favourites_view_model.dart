import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shopping_app/models/favourite.dart';
import 'package:shopping_app/models/product.dart';
import 'package:shopping_app/repositories/favourites_repo.dart';
import 'package:shopping_app/repositories/products_repo.dart';
import 'package:shopping_app/services/locator_service.dart';
import 'package:shopping_app/viewmodels/auth_view_model.dart';
import 'package:shopping_app/viewmodels/state_view_model.dart';

abstract class IFavouritesViewModel extends IStateViewModel {
  bool get isLoading;
  List<Favourite>? get favourites;
  void addProductToFavourites(Product product);
  bool isProductFavourited(Product product);
  void toggleFavourite(Product product);
  void removeFavourite(Product product, {SlidableController? slidable});
}

class FavouritesViewModel extends IFavouritesViewModel {
  final IFavoutiresRepo _favoutiresRepo;
  final IProductsRepo _productsRepo;
  final List<Favourite> _favourites = [];
  late final IAuthViewModel _authViewModel;
  String? _errorCode;
  String? _successCode;

  final ValueNotifier<ViewModelState> _state =
      ValueNotifier(ViewModelState.idle);

  FavouritesViewModel({
    required IFavoutiresRepo favoutiresRepo,
    required IProductsRepo productsRepo,
  })  : _favoutiresRepo = favoutiresRepo,
        _productsRepo = productsRepo {
    _authViewModel = sl.get();
    if (_authViewModel.isLoggedIn) {
      _listenToFavs(_authViewModel.currentUser!.uid);
    }
    _authViewModel.addListener(() {
      if (_authViewModel.isLoggedIn) {
        _favourites.clear();
        _listenToFavs(_authViewModel.currentUser!.uid);
      }
    });
    addListener(() {
      snackBarListener(this);
    });
  }

  @override
  bool get isLoading => state.value == ViewModelState.loading;

  @override
  List<Favourite> get favourites => _favourites;

  @override
  String? get errorMessage => _errorCode;

  @override
  String? get successMessage => _successCode;

  @override
  ValueNotifier<ViewModelState> get state => _state;

  @override
  bool isProductFavourited(Product product) {
    try {
      favourites.firstWhere((favourite) => favourite.product == product);
    } on StateError catch (_) {
      return false;
    }
    return true;
  }

  @override
  void addProductToFavourites(Product product) async {
    _setState(ViewModelState.loading);
    if (_authViewModel.isLoggedIn) {
      try {
        await _favoutiresRepo.addProductToFavourites(
          favourite: Favourite(
            userId: _authViewModel.currentUser!.uid,
            productId: product.id,
            product: product,
          ),
        );
        _setSuccessMessage('You have added ${product.title} to favourites');
        _setErrorMessage(null);
        _setState(ViewModelState.success);
      } catch (error) {
        _setErrorMessage(error.toString());
        _setState(ViewModelState.error);
      }
    } else {
      _setErrorMessage('Log in to add product to favourites');
      _setState(ViewModelState.error);
    }
    _setState(ViewModelState.idle);
  }

  @override
  void toggleFavourite(Product product) {
    if (isProductFavourited(product)) {
      removeFavourite(product);
    } else {
      addProductToFavourites(product);
    }
  }

  @override
  void removeFavourite(Product product, {SlidableController? slidable}) async {
    _setState(ViewModelState.loading);
    if (_authViewModel.isLoggedIn) {
      final fav = Favourite(
        userId: _authViewModel.currentUser!.uid,
        productId: product.id,
      );
      _favourites.remove(fav);
      try {
        await _favoutiresRepo.removeFavourite(
          favourite: fav,
        );
        _setSuccessMessage('You have removed ${product.title} from favourites');
        _setErrorMessage(null);
        _setState(ViewModelState.success);
      } on StateError catch (error) {
        _setErrorMessage(error.message);
        _setState(ViewModelState.error);
      }
    }
  }

  @override
  void resetState() {
    _setErrorMessage(null);
    _setSuccessMessage(null);
    _setState(ViewModelState.idle);
  }

  void _listenToFavs(String userId) {
    _favoutiresRepo.listenToFavourites(userId).listen((favData) async {
      _setState(ViewModelState.loading);
      List<Favourite> updatedFavs = favData;
      if (updatedFavs.isNotEmpty) {
        await _updateList(updatedFavs);
      }
      _setState(ViewModelState.idle);
    });
  }

  Future _updateList(List<Favourite> updatedFavs) async {
    final newFavs = updatedFavs.where((fav) => !_favourites.contains(fav));
    for (var fav in newFavs) {
      fav.product = await _loadProductInfo(productId: fav.productId);
    }
    _favourites.addAll(newFavs);
    _favourites.removeWhere((element) => !updatedFavs.contains(element));
  }

  void _setState(ViewModelState newState) async {
    await _waitFrame();
    state.value = newState;
    state.notifyListeners();
    notifyListeners();
  }

  void _setSuccessMessage(String? sucessCode) {
    _successCode = sucessCode;
  }

  void _setErrorMessage(String? errorCode) {
    _errorCode = errorCode;
  }

  Future<void> _waitFrame() async {
    if (SchedulerBinding.instance.schedulerPhase != SchedulerPhase.idle) {
      await SchedulerBinding.instance.endOfFrame;
    }
  }

  Future<Product> _loadProductInfo({required int productId}) async {
    return _productsRepo.getProductById(productId: productId);
  }
}
