import 'package:flutter/foundation.dart';

import '../../data/repositories/product_repository_impl.dart';
import '../../domain/entities/product.dart';

class ProductViewModel extends ChangeNotifier {
  ProductViewModel({ProductRepositoryImpl? repository})
      : _repository = repository ?? ProductRepositoryImpl();

  final ProductRepositoryImpl _repository;

  bool isLoading = false;
  String? errorMessage;
  final List<Product> items = [];

  Future<void> loadProducts() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final products = await _repository.fetchProducts();
      items
        ..clear()
        ..addAll(products);
    } catch (e) {
      errorMessage = 'Falha ao carregar produtos: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createProduct(Product product) async {
    errorMessage = null;
    notifyListeners();

    try {
      final created = await _repository.addProduct(product);
      items.insert(0, created);
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = 'Falha ao cadastrar produto: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> editProduct(Product product) async {
    if (product.id == null || product.id!.isEmpty) {
      errorMessage = 'Produto sem ID para atualização.';
      notifyListeners();
      return false;
    }

    errorMessage = null;
    notifyListeners();

    try {
      final updated = await _repository.updateProduct(product);
      final index = items.indexWhere((item) => item.id == updated.id);
      if (index >= 0) {
        items[index] = updated;
      } else {
        items.insert(0, updated);
      }
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = 'Falha ao atualizar produto: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeProduct(Product product) async {
    if (product.id == null || product.id!.isEmpty) {
      errorMessage = 'Produto sem ID para exclusão.';
      notifyListeners();
      return false;
    }

    errorMessage = null;
    final index = items.indexWhere((item) => item.id == product.id);
    Product? removed;
    if (index >= 0) {
      removed = items.removeAt(index);
      notifyListeners();
    }

    try {
      await _repository.deleteProduct(product.id!);
      return true;
    } catch (e) {
      if (removed != null) {
        items.insert(index, removed);
      }
      errorMessage = 'Falha ao excluir produto: $e';
      notifyListeners();
      return false;
    }
  }
}
