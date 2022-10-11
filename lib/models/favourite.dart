import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app/models/product.dart';

class Favourite {
  final String userId;
  final int productId;
  Product? product;

  Favourite({
    required this.userId,
    required this.productId,
    this.product,
  });

  factory Favourite.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Favourite(
      userId: data?['userId'],
      productId: data?['productId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'productId': productId,
    };
  }

  @override
  bool operator ==(Object other) =>
      other is Favourite &&
      userId == other.userId &&
      productId == other.productId;

  @override
  int get hashCode => Object.hash(userId.hashCode, productId.hashCode);
}
