import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shopping_app/globals.dart';
import 'package:shopping_app/models/favourite.dart';
import 'package:shopping_app/models/product.dart';
import 'package:shopping_app/repositories/favourites_repo.dart';
import 'package:shopping_app/repositories/products_repo.dart';
import 'package:shopping_app/services/locator_service.dart';
import 'package:shopping_app/viewmodels/auth_view_model.dart';

abstract class IFavouritesViewModel with ChangeNotifier {
  bool get isLoading;
  List<Favourite>? get favourites;
  void addProductToFavourites(Product product);
  bool isProductFavourited(Product product);
  void toggleFavourite(Product product);
  void removeFavourite(Product product, {SlidableController? slidable});
  bool get isLoadingProduct;
}

class FavouritesViewModel with ChangeNotifier implements IFavouritesViewModel {
  final IFavoutiresRepo _favoutiresRepo;
  final IProductsRepo _productsRepo;
  final List<Favourite> _favourites = [];
  bool _isLoadingProduct = false;
  bool _isLoading = false;
  late final IAuthViewModel _authViewModel;

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
  }

  @override
  bool get isLoading => _isLoading;

  @override
  bool get isLoadingProduct => _isLoadingProduct;

  @override
  List<Favourite> get favourites => _favourites;

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
  void addProductToFavourites(Product product) {
    _setLoadingProduct(true);
    if (_authViewModel.isLoggedIn) {
      _favoutiresRepo.addProductToFavourites(
        favourite: Favourite(
          userId: _authViewModel.currentUser!.uid,
          productId: product.id,
        ),
      );
    } else {
      _showSnackBar(
        snackBarText: 'Log in to add product to favourites',
        isError: true,
      );
    }
    _setLoadingProduct(false);
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
    _setLoading(true);
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
        _showSnackBar(
          snackBarText: 'You have removed ${product.title} from favourites',
          isError: false,
        );
      } on StateError catch (error) {
        _showSnackBar(
          snackBarText: error.message,
          isError: true,
        );
      }
    }
    _setLoading(false);
  }

  void _listenToFavs(String userId) {
    _favoutiresRepo.listenToFavourites(userId).listen((favData) async {
      _setLoading(true);
      List<Favourite> updatedFavs = favData;
      if (updatedFavs.isNotEmpty) {
        await _updateList(updatedFavs);
      }
      _setLoading(false);
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

  void _setLoading(bool isLoading) async {
    await _waitFrame();
    _isLoading = isLoading;
    notifyListeners();
  }

  void _setLoadingProduct(bool isLoadingProduct) async {
    await _waitFrame();
    _isLoadingProduct = isLoadingProduct;
    notifyListeners();
  }

  Future<void> _waitFrame() async {
    if (SchedulerBinding.instance.schedulerPhase != SchedulerPhase.idle) {
      await SchedulerBinding.instance.endOfFrame;
    }
  }

  Future<Product> _loadProductInfo({required int productId}) async {
    return _productsRepo.getProductById(productId: productId);
  }

  _showSnackBar({required String snackBarText, required bool isError}) {
    snackbarKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(snackBarText),
        backgroundColor: isError ? Colors.red : Colors.teal,
      ),
    );
  }
}
