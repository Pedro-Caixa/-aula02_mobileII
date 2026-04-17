import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    super.id,
    required super.name,
    required super.price,
    required super.description,
    super.imageUrl,
    super.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString(),
      name: (json['name'] ?? json['title'] ?? '').toString(),
      price: _parsePrice(json['price']),
      description: (json['description'] ?? '').toString(),
      imageUrl: (json['image'] ?? json['imageUrl'])?.toString(),
      category: json['category']?.toString(),
    );
  }

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      price: product.price,
      description: product.description,
      imageUrl: product.imageUrl,
      category: product.category,
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

  static double _parsePrice(dynamic rawPrice) {
    if (rawPrice is num) return rawPrice.toDouble();
    if (rawPrice is String) return double.tryParse(rawPrice) ?? 0;
    return 0;
  }
}
