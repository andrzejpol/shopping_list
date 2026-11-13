import 'package:flutter/material.dart';
import 'package:shopping_list/features/shopping_list/domain/entities/catalog_product.dart';
import 'package:shopping_list/features/shopping_list/domain/entities/shopping_categories.dart';

class AddItemSheet extends StatefulWidget {
  final List<CatalogProduct> suggestions;

  const AddItemSheet({super.key, this.suggestions = const []});

  @override
  State<AddItemSheet> createState() => _AddItemSheetState();
}

class _AddItemSheetState extends State<AddItemSheet> {
  final _nameController = TextEditingController();
  final _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  String _category = shoppingCategories.first;

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);
      return;
    }

    Navigator.of(context).pop((
      name: _nameController.text,
      note: _noteController.text,
      category: _category,
    ));
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Podaj nazwę produktu';
    }
    if (value.trim().length > 50) {
      return 'Przekroczono limit 50 znaków';
    }
    return null;
  }

  void _addFromCatalog(CatalogProduct product) {
    Navigator.of(context)
        .pop((name: product.name, category: product.category, note: ''));
  }

  List<CatalogProduct> _visibleSuggestions() {
    final query = _nameController.text.trim().toLowerCase();
    final matching = query.isEmpty
        ? widget.suggestions
        : widget.suggestions.where(
            (product) => product.name.toLowerCase().contains(query),
          );
    return matching.take(10).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final suggestions = _visibleSuggestions();

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: Form(
        key: _formKey,
        autovalidateMode: _autovalidateMode,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            Text('Nowy produkt', style: theme.textTheme.titleLarge),
            TextFormField(
              controller: _nameController,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Nazwa'),
              validator: _validateName,
              onChanged: (_) => setState(() {}),
            ),
            if (suggestions.isNotEmpty) ...[
              Text(
                'Często kupowane',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: suggestions.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final product = suggestions[index];
                    return ActionChip(
                      avatar: product.isPinned
                          ? const Icon(Icons.star, size: 18)
                          : null,
                      label: Text(product.name),
                      onPressed: () => _addFromCatalog(product),
                    );
                  },
                ),
              ),
            ],
            TextFormField(
              controller: _noteController,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(labelText: 'Notatka'),
              onFieldSubmitted: (_) => _submit(),
            ),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Kategoria'),
              items: shoppingCategories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _category = value);
                }
              },
            ),
            FilledButton(onPressed: _submit, child: const Text('Dodaj')),
          ],
        ),
      ),
    );
  }
}
