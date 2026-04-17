import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductService {
  ProductService({
    http.Client? client,
    this.baseUrl = 'https://fakestoreapi.com/products',
  })  : _client = client ?? http.Client(),
        _ownsClient = client == null;

  final http.Client _client;
  final bool _ownsClient;
  final String baseUrl;

  Future<List<Product>> fetchProducts() async {
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
        .map(Product.fromJson)
        .toList();
  }

  Future<Product> addProduct(Product product) async {
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

    return Product.fromJson(decoded);
  }

  Future<Product> updateProduct(Product product) async {
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

    return Product.fromJson(decoded);
  }

  Future<void> deleteProduct(String id) async {
    final response = await _client.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Falha ao excluir produto: ${response.statusCode}');
    }
  }

  void dispose() {
    if (_ownsClient) {
      _client.close();
    }
  }
}
