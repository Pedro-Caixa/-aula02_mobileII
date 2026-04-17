import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product_model.dart';

class ProductRemoteDataSource {
  ProductRemoteDataSource({
    http.Client? client,
    this.baseUrl = 'https://fakestoreapi.com/products',
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;

  Future<List<ProductModel>> fetchProducts() async {
    final response = await _client.get(Uri.parse(baseUrl));
    if (response.statusCode != 200) {
      throw Exception('Falha ao carregar produtos: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw Exception('Resposta inesperada ao listar produtos.');
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(ProductModel.fromJson)
        .toList();
  }

  Future<ProductModel> addProduct(ProductModel product) async {
    final payload = product.toJson()..remove('id');

    final response = await _client.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Falha ao cadastrar produto: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Resposta inesperada ao cadastrar produto.');
    }

    return ProductModel.fromJson(decoded);
  }

  Future<ProductModel> updateProduct(ProductModel product) async {
    if (product.id == null || product.id!.isEmpty) {
      throw Exception('Produto sem ID para atualização.');
    }

    final response = await _client.put(
      Uri.parse('$baseUrl/${product.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao atualizar produto: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Resposta inesperada ao atualizar produto.');
    }

    return ProductModel.fromJson(decoded);
  }

  Future<void> deleteProduct(String id) async {
    final response = await _client.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Falha ao excluir produto: ${response.statusCode}');
    }
  }
}
