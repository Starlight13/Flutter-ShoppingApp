class Product {
  final int id;
  final String title;
  final String description;
  final int price;
  final String thumbnail;
  final List<String> images;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.images,
    required this.thumbnail,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      price: map['price'] as int,
      images: (map['images'] as List<dynamic>).map((e) => e as String).toList(),
      thumbnail: map['thumbnail'] as String,
    );
  }

  String get shortDescription {
    return trimText(description, 70);
  }

  String get shortTitle {
    return trimText(title, 25);
  }

  String trimText(String text, int maxChars) {
    if (text.length > maxChars) {
      return '${text.substring(0, maxChars)}...';
    }
    return text;
  }

  @override
  bool operator ==(Object other) => other is Product && id == other.id;

  @override
  int get hashCode => Object.hash(id.hashCode, title.hashCode);
}
