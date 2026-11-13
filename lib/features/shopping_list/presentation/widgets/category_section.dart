import 'package:flutter/material.dart';
import 'package:shopping_list/features/shopping_list/domain/entities/shopping_item.dart';
import 'package:shopping_list/features/shopping_list/presentation/widgets/shopping_item_tile.dart';

class CategorySection extends StatelessWidget {
  final String category;
  final List<ShoppingItem> items;
  final void Function(ShoppingItem item) onToggle;
  final void Function(ShoppingItem item) onRemove;

  const CategorySection({
    super.key,
    required this.category,
    required this.items,
    required this.onToggle,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final boughtCount = items.where((item) => item.isBought).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  category,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '$boughtCount/${items.length}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Card(
          child: Column(
            children: [
              for (final (index, item) in items.indexed) ...[
                if (index > 0) const Divider(height: 1, indent: 56),
                Dismissible(
                  key: ValueKey(item.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => onRemove(item),
                  background: Container(
                    color: theme.colorScheme.error,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: Icon(
                      Icons.delete_outline,
                      color: theme.colorScheme.onError,
                    ),
                  ),
                  child: ShoppingItemTile(
                    item: item,
                    onToggle: () => onToggle(item),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
