import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/product.dart';
import '../viewmodels/product_viewmodel.dart';
import '../widgets/product_card.dart';
import 'product_detail_page.dart';
import 'product_form_page.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductViewModel>().loadProducts();
    });
  }

  Future<void> _openForm({Product? product}) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ProductFormPage(product: product),
      ),
    );

    if (!mounted) return;
    if (saved == true) {
      final vm = context.read<ProductViewModel>();
      await vm.loadProducts();
    }
  }

  Future<void> _delete(Product product) async {
    final vm = context.read<ProductViewModel>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
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
      ),
    );

    if (confirmed != true) return;

    final success = await vm.removeProduct(product);
    if (!mounted) return;

    if (!success) {
      final message = vm.errorMessage ?? 'Erro ao excluir produto.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Produto excluído com sucesso.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        actions: [
          IconButton(
            onPressed: vm.isLoading ? null : vm.loadProducts,
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
      body: _body(vm),
    );
  }

  Widget _body(ProductViewModel vm) {
    if (vm.isLoading && vm.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.errorMessage != null && vm.items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(vm.errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: vm.loadProducts,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    if (vm.items.isEmpty) {
      return const Center(child: Text('Nenhum produto encontrado.'));
    }

    return RefreshIndicator(
      onRefresh: vm.loadProducts,
      child: ListView.builder(
        itemCount: vm.items.length,
        itemBuilder: (_, index) {
          final product = vm.items[index];
          return ProductCard(
            product: product,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ProductDetailPage(product: product),
                ),
              );
            },
            onEdit: () => _openForm(product: product),
            onDelete: () => _delete(product),
          );
        },
      ),
    );
  }
}
