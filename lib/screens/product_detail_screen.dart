import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Produto')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (product.imageUrl != null && product.imageUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product.imageUrl!,
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return const SizedBox(
                    height: 220,
                    child: Center(
                      child: Icon(Icons.image_not_supported_outlined),
                    ),
                  );
                },
              ),
            )
          else
            Container(
              height: 220,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.inventory_2_outlined, size: 64),
            ),
          const SizedBox(height: 16),
          Text(
            product.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'R\$ ${product.price.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (product.category != null && product.category!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Chip(label: Text(product.category!)),
          ],
          const SizedBox(height: 16),
          Text(
            product.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          Text(
            'ID: ${product.id ?? '-'}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
