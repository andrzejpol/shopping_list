import 'package:flutter/material.dart';
import 'package:shopping_list/core/utils/polish_plural.dart';
import 'package:shopping_list/features/shopping_list/domain/entities/catalog_product.dart';

class CatalogProductTile extends StatelessWidget {
  final CatalogProduct product;
  final VoidCallback onTap;
  final VoidCallback onTogglePinned;
  final VoidCallback onAddToList;

  const CatalogProductTile({
    super.key,
    required this.product,
    required this.onTap,
    required this.onTogglePinned,
    required this.onAddToList,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = product.useCount;

    return ListTile(
      onTap: onTap,
      leading: IconButton(
        onPressed: onTogglePinned,
        icon: Icon(product.isPinned ? Icons.star : Icons.star_border),
        color: product.isPinned ? theme.colorScheme.primary : null,
        tooltip: product.isPinned ? 'Odepnij' : 'Przypnij',
      ),
      title: Text(product.name),
      subtitle: Text(
        count == 0
            ? 'Dodany ręcznie'
            : 'Kupowany $count ${pluralize(count, 'raz', 'razy', 'razy')}',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: IconButton(
        onPressed: onAddToList,
        icon: const Icon(Icons.add_shopping_cart),
        tooltip: 'Dodaj do listy',
      ),
    );
  }
}
