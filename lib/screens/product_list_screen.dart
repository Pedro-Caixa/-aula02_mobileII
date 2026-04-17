import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';
import 'product_form_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late final ProductService _service;
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _service = ProductService();
    _productsFuture = _service.fetchProducts();
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    setState(() {
      _productsFuture = _service.fetchProducts();
    });
  }

  Future<void> _openForm({Product? product}) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ProductFormScreen(
          service: _service,
          product: product,
        ),
      ),
    );

    if (saved == true) {
      await _reload();
    }
  }

  Future<void> _delete(Product product) async {
    if (product.id == null || product.id!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto sem ID para exclusão.')),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Excluir produto'),
          content: Text('Deseja excluir "${product.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await _service.deleteProduct(product.id!);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto excluído com sucesso.')),
      );
      await _reload();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir produto: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        actions: [
          IconButton(
            onPressed: _reload,
            icon: const Icon(Icons.refresh),
            tooltip: 'Atualizar',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Novo produto'),
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Erro ao carregar produtos:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: _reload,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            );
          }

          final products = snapshot.data ?? const [];
          if (products.isEmpty) {
            return const Center(child: Text('Nenhum produto encontrado.'));
          }

          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (_, index) {
                final product = products[index];
                return ProductCard(
                  product: product,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(product: product),
                      ),
                    );
                  },
                  onEdit: () => _openForm(product: product),
                  onDelete: () => _delete(product),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
