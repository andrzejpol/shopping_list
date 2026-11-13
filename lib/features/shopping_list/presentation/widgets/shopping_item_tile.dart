import 'package:flutter/material.dart';
import 'package:shopping_list/features/shopping_list/domain/entities/shopping_item.dart';

class ShoppingItemTile extends StatelessWidget {
  final ShoppingItem item;
  final VoidCallback onToggle;

  const ShoppingItemTile({
    super.key,
    required this.item,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final note = item.note;

    return CheckboxListTile(
      value: item.isBought,
      onChanged: (_) => onToggle(),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      title: Text(
        item.name,
        style: theme.textTheme.bodyLarge?.copyWith(
          decoration: item.isBought ? TextDecoration.lineThrough : null,
          color: item.isBought
              ? theme.colorScheme.onSurfaceVariant
              : theme.colorScheme.onSurface,
        ),
      ),
      subtitle: note != null
          ? Text(
              note,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          : null,
    );
  }
}
