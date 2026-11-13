import 'package:shopping_list/features/shopping_list/domain/entities/catalog_product.dart';
import 'package:shopping_list/features/shopping_list/domain/entities/shopping_categories.dart';

extension CatalogProductListExtensions on List<CatalogProduct> {
  List<CatalogProduct> sortedForSuggestions() {
    return [...this]..sort((a, b) {
      if (a.isPinned != b.isPinned) return a.isPinned ? -1 : 1;

      final byUseCount = b.useCount.compareTo(a.useCount);
      if (byUseCount != 0) return byUseCount;

      return a.name.compareTo(b.name);
    });
  }

  Map<String, List<CatalogProduct>> groupedByCategory() {
    final groups = <String, List<CatalogProduct>>{};
    for (final product in this) {
      groups.putIfAbsent(product.category, () => []).add(product);
    }

    for (final products in groups.values) {
      products.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
    }

    return {
      for (final category in shoppingCategories)
        if (groups.containsKey(category)) category: groups[category]!,
      for (final entry in groups.entries)
        if (!shoppingCategories.contains(entry.key)) entry.key: entry.value,
    };
  }
}
