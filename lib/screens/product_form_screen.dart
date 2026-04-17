import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/product_service.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({
    super.key,
    required this.service,
    this.product,
  });

  final ProductService service;
  final Product? product;

  bool get isEditing => product != null;

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _imageController;
  late final TextEditingController _categoryController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameController = TextEditingController(text: p?.name ?? '');
    _priceController = TextEditingController(
      text: p != null ? p.price.toStringAsFixed(2) : '',
    );
    _descriptionController = TextEditingController(text: p?.description ?? '');
    _imageController = TextEditingController(text: p?.imageUrl ?? '');
    _categoryController = TextEditingController(text: p?.category ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSaving) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final price = double.parse(_priceController.text.replaceAll(',', '.'));

    final product = Product(
      id: widget.product?.id,
      name: _nameController.text.trim(),
      price: price,
      description: _descriptionController.text.trim(),
      imageUrl: _imageController.text.trim().isEmpty
          ? null
          : _imageController.text.trim(),
      category: _categoryController.text.trim().isEmpty
          ? null
          : _categoryController.text.trim(),
    );

    try {
      if (widget.isEditing) {
        await widget.service.updateProduct(product);
      } else {
        await widget.service.addProduct(product);
      }

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar produto: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Editar Produto' : 'Cadastrar Produto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o nome do produto';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Preço'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o preço';
                  }
                  final normalized = value.replaceAll(',', '.');
                  final parsed = double.tryParse(normalized);
                  if (parsed == null || parsed < 0) {
                    return 'Preço inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                minLines: 2,
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe a descrição';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Categoria'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'URL da imagem'),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isSaving ? null : _submit,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(_isSaving ? 'Salvando...' : 'Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
