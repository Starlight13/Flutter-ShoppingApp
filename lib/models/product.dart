class Product {
  final int id;
  final String title;
  final String description;
  final int price;
  final String thumbnail;
  final List<String> images;
  final String category;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.images,
    required this.thumbnail,
    required this.category,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      price: map['price'] as int,
      images: (map['images'] as List<dynamic>).map((e) => e as String).toList(),
      thumbnail: map['thumbnail'] as String,
      category: map['category'] as String,
    );
  }

  @override
  bool operator ==(Object other) => other is Product && id == other.id;

  @override
  int get hashCode => Object.hash(id.hashCode, title.hashCode);
}
