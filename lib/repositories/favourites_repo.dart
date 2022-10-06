import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app/models/favourite.dart';
import 'package:shopping_app/services/favourites_service.dart';

abstract class IFavoutiresRepo {
  Future<List<Favourite>> getFavouritesForUser(String userId);
  Future<DocumentReference<Map<String, dynamic>>> addProductToFavourites({
    required Favourite favourite,
  });
  Stream listenToFavourites(String userId);
  Future<void> removeFavourite({required Favourite favourite});
}

class FavouritesRepo implements IFavoutiresRepo {
  late final IFavouritesService _favouritesService;
  final StreamController<List<Favourite>> _favController =
      StreamController<List<Favourite>>.broadcast();

  FavouritesRepo({
    required IFavouritesService favouritesService,
  }) : _favouritesService = favouritesService;

  @override
  Future<List<Favourite>> getFavouritesForUser(String userId) async {
    List<Favourite> favourites = [];
    await for (final snapshot
        in _favouritesService.getFavouritesForUser(userId: userId)) {
      for (var favourite in snapshot.docs) {
        favourites.add(Favourite.fromFirestore(favourite, null));
      }
    }
    return favourites;
  }

  @override
  Stream<List<Favourite>> listenToFavourites(String userId) {
    _favouritesService
        .getFavouritesForUser(userId: userId)
        .listen((favSnapshot) {
      if (favSnapshot.docs.isNotEmpty) {
        final favourites = favSnapshot.docs
            .map((snapshot) => Favourite.fromFirestore(snapshot, null))
            .toList();
        _favController.add(favourites);
      }
    });
    return _favController.stream;
  }

  @override
  Future<DocumentReference<Map<String, dynamic>>> addProductToFavourites({
    required Favourite favourite,
  }) {
    return _favouritesService.addProductToFavourites(favourite: favourite);
  }

  Future<QueryDocumentSnapshot<Map<String, dynamic>>?> getFavourite({
    required Favourite favourite,
  }) async {
    final snapshot = await _favouritesService.getFavourite(
      userId: favourite.userId,
      productId: favourite.productId,
    );
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs[0];
    }
    return null;
  }

  @override
  Future<void> removeFavourite({required Favourite favourite}) async {
    final fav = await getFavourite(favourite: favourite);
    if (fav != null) {
      return _favouritesService.removeFavourite(favouriteRef: fav.reference);
    } else {
      throw StateError('The product is not favourite');
    }
  }
}
