class Product {
  const Product({
    this.id,
    required this.name,
    required this.price,
    required this.description,
    this.imageUrl,
    this.category,
  });

  final String? id;
  final String name;
  final double price;
  final String description;
  final String? imageUrl;
  final String? category;

  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? description,
    String? imageUrl,
    String? category,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
    );
  }
}
