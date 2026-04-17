import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> fetchProducts();
  Future<Product> addProduct(Product product);
  Future<Product> updateProduct(Product product);
  Future<void> deleteProduct(String id);
}
