import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({ProductRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? ProductRemoteDataSource();

  final ProductRemoteDataSource _remoteDataSource;

  @override
  Future<List<Product>> fetchProducts() async {
    return _remoteDataSource.fetchProducts();
  }

  @override
  Future<Product> addProduct(Product product) async {
    final model = ProductModel.fromEntity(product);
    return _remoteDataSource.addProduct(model);
  }

  @override
  Future<Product> updateProduct(Product product) async {
    final model = ProductModel.fromEntity(product);
    return _remoteDataSource.updateProduct(model);
  }

  @override
  Future<void> deleteProduct(String id) {
    return _remoteDataSource.deleteProduct(id);
  }
}
