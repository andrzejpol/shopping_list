import 'package:equatable/equatable.dart';
import 'package:shopping_list/core/failures/data_failure.dart';
import 'package:shopping_list/features/shopping_list/domain/catalog_key.dart';
import 'package:shopping_list/features/shopping_list/domain/entities/catalog_product.dart';
import 'package:shopping_list/features/shopping_list/domain/entities/catalog_product_list_extensions.dart';
import 'package:shopping_list/features/shopping_list/domain/entities/shopping_item.dart';
import 'package:shopping_list/features/shopping_list/domain/entities/shopping_item_list_extensions.dart';

class ShoppingListState extends Equatable {
  final List<ShoppingItem> items;
  final List<CatalogProduct> catalog;
  final bool isLoading;
  final String searchQuery;
  final DataFailure? failure;

  const ShoppingListState({
    this.items = const [],
    this.catalog = const [],
    this.isLoading = true,
    this.searchQuery = '',
    this.failure,
  });

  List<ShoppingItem> get visibleItems => items.search(searchQuery);

  int get boughtCount => items.where((item) => item.isBought).length;

  Map<String, List<ShoppingItem>> get groupedVisibleItems => {
    for (final entry in visibleItems.groupByCategory().entries)
      entry.key: entry.value.sortedByBought(),
  };

  List<CatalogProduct> get suggestions {
    final onListKeys = items
        .where((item) => !item.isBought)
        .map((item) => catalogKeyFor(item.name))
        .toSet();

    return catalog
        .where((product) => !onListKeys.contains(product.id))
        .toList()
        .sortedForSuggestions();
  }

  ShoppingListState copyWith({
    List<ShoppingItem>? items,
    List<CatalogProduct>? catalog,
    bool? isLoading,
    String? searchQuery,
    DataFailure? failure,
    bool clearFailure = false,
  }) {
    return ShoppingListState(
      items: items ?? this.items,
      catalog: catalog ?? this.catalog,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }

  @override
  List<Object?> get props => [items, catalog, isLoading, searchQuery, failure];
}
