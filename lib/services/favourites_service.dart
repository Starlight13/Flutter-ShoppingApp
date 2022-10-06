import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app/models/favourite.dart';

abstract class IFavouritesService {
  Stream<QuerySnapshot<Map<String, dynamic>>> getFavouritesForUser({
    required String userId,
  });
  void addProductToFavourites({required Favourite favourite});
  Future<QuerySnapshot<Map<String, dynamic>>> getFavourite({
    required String userId,
    required int productId,
  });
  Future<void> removeFavourite({required DocumentReference favouriteRef});
}

class FavouritesService implements IFavouritesService {
  final CollectionReference<Map<String, dynamic>>
      _favouritesCollectionReference =
      FirebaseFirestore.instance.collection('favourites');

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getFavouritesForUser({
    required String userId,
  }) {
    return _favouritesCollectionReference
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  @override
  void addProductToFavourites({required Favourite favourite}) {
    _favouritesCollectionReference.add(favourite.toFirestore());
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> getFavourite({
    required String userId,
    required int productId,
  }) {
    return _favouritesCollectionReference
        .where('userId', isEqualTo: userId)
        .where('productId', isEqualTo: productId)
        .limit(1)
        .get();
  }

  @override
  Future<void> removeFavourite({required DocumentReference favouriteRef}) {
    return favouriteRef.delete();
  }
}
