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

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString(),
      name: (json['name'] ?? json['title'] ?? '').toString(),
      price: _parsePrice(json['price']),
      description: (json['description'] ?? '').toString(),
      imageUrl: (json['image'] ?? json['imageUrl'])?.toString(),
      category: json['category']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'name': name,
      'title': name,
      'price': price,
      'description': description,
      'image': imageUrl,
      'category': category,
    };

    if (id != null && id!.isNotEmpty) {
      map['id'] = id;
    }

    return map;
  }

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

  static double _parsePrice(dynamic rawPrice) {
    if (rawPrice is num) return rawPrice.toDouble();
    if (rawPrice is String) return double.tryParse(rawPrice) ?? 0;
    return 0;
  }
}
