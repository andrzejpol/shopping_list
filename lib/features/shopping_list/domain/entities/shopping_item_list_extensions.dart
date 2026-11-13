import 'package:shopping_list/features/shopping_list/domain/entities/shopping_categories.dart';
import 'package:shopping_list/features/shopping_list/domain/entities/shopping_item.dart';

extension ShoppingItemListExtensions on List<ShoppingItem> {
  List<ShoppingItem> search(String query) {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) return this;

    return where((item) {
      final nameMatches = item.name.toLowerCase().contains(normalizedQuery);
      final noteMatches =
          item.note?.toLowerCase().contains(normalizedQuery) ?? false;
      return nameMatches || noteMatches;
    }).toList();
  }

  Map<String, List<ShoppingItem>> groupByCategory() {
    final groups = <String, List<ShoppingItem>>{};
    for (final item in this) {
      groups.putIfAbsent(item.category, () => []).add(item);
    }

    return {
      for (final category in shoppingCategories)
        if (groups.containsKey(category)) category: groups[category]!,
      for (final entry in groups.entries)
        if (!shoppingCategories.contains(entry.key)) entry.key: entry.value,
    };
  }

  List<ShoppingItem> sortedByBought() {
    return [
      ...where((item) => !item.isBought),
      ...where((item) => item.isBought),
    ];
  }
}
