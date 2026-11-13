import 'package:flutter/material.dart';
import 'package:shopping_list/features/shopping_list/domain/entities/catalog_product.dart';
import 'package:shopping_list/features/shopping_list/domain/entities/shopping_categories.dart';

class CatalogProductSheet extends StatefulWidget {
  final CatalogProduct? product;

  const CatalogProductSheet({super.key, this.product});

  @override
  State<CatalogProductSheet> createState() => _CatalogProductSheetState();
}

class _CatalogProductSheetState extends State<CatalogProductSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(
    text: widget.product?.name,
  );
  late String _category = _initialCategory();

  bool get _isEditing => widget.product != null;

  String _initialCategory() {
    final category = widget.product?.category;
    return category != null && shoppingCategories.contains(category)
        ? category
        : shoppingCategories.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Podaj nazwę produktu';
    if (value.trim().length > 50)
      return 'Nazwa może mieć maksymalnie 50 znaków';
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.of(context)
        .pop((name: _nameController.text, category: _category));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            Text(
              _isEditing ? 'Edytuj produkt' : 'Nowy produkt',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextFormField(
              controller: _nameController,
              autofocus: !_isEditing,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(labelText: 'Nazwa'),
              validator: _validateName,
            ),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Kategoria'),
              items: shoppingCategories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _category = value);
              },
            ),
            FilledButton(
              onPressed: _submit,
              child: Text(_isEditing ? 'Zapisz' : 'Dodaj'),
            ),
          ],
        ),
      ),
    );
  }
}
