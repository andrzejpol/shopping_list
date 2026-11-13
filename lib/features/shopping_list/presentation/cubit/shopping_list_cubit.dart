import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/core/failures/data_failure.dart';
import 'package:shopping_list/features/shopping_list/domain/entities/catalog_product.dart';
import 'package:shopping_list/features/shopping_list/domain/entities/shopping_item.dart';
import 'package:shopping_list/features/shopping_list/domain/usecases/add_shopping_item.dart';
import 'package:shopping_list/features/shopping_list/domain/usecases/remove_shopping_item.dart';
import 'package:shopping_list/features/shopping_list/domain/usecases/toggle_item_bought.dart';
import 'package:shopping_list/features/shopping_list/domain/usecases/watch_catalog_products.dart';
import 'package:shopping_list/features/shopping_list/domain/usecases/watch_shopping_items.dart';
import 'package:shopping_list/features/shopping_list/presentation/cubit/shopping_list_state.dart';

class ShoppingListCubit extends Cubit<ShoppingListState> {
  ShoppingListCubit({
    required WatchShoppingItems watchShoppingItems,
    required WatchCatalogProducts watchCatalogProducts,
    required AddShoppingItem addShoppingItem,
    required ToggleItemBought toggleItemBought,
    required RemoveShoppingItem removeShoppingItem,
  }) : _watchShoppingItems = watchShoppingItems,
       _watchCatalogProducts = watchCatalogProducts,
       _addShoppingItem = addShoppingItem,
       _toggleItemBought = toggleItemBought,
       _removeShoppingItem = removeShoppingItem,
       super(const ShoppingListState());

  final WatchShoppingItems _watchShoppingItems;
  final WatchCatalogProducts _watchCatalogProducts;
  final AddShoppingItem _addShoppingItem;
  final ToggleItemBought _toggleItemBought;
  final RemoveShoppingItem _removeShoppingItem;

  late final String _householdId;
  StreamSubscription<List<ShoppingItem>>? _itemsSubscription;
  StreamSubscription<List<CatalogProduct>>? _catalogSubscription;

  void init(String householdId) {
    _householdId = householdId;
    _subscribe();
  }

  void _subscribe() {
    _itemsSubscription = _watchShoppingItems(_householdId).listen(
      (items) => emit(
        state.copyWith(items: items, isLoading: false, clearFailure: true),
      ),
      onError: (Object error) => emit(
        state.copyWith(
          isLoading: false,
          failure: error is DataFailure ? error : const UnknownDataFailure(),
        ),
      ),
    );

    _catalogSubscription = _watchCatalogProducts(_householdId).listen(
      (catalog) => emit(state.copyWith(catalog: catalog)),
      onError: (Object error) {},
    );
  }

  Future<void> retry() async {
    await _itemsSubscription?.cancel();
    await _catalogSubscription?.cancel();
    emit(state.copyWith(isLoading: true, clearFailure: true));
    _subscribe();
  }

  Future<void> refresh() async {
    await _itemsSubscription?.cancel();
    await _catalogSubscription?.cancel();
    _subscribe();
  }

  Future<void> addItem({
    required String name,
    required String category,
    String? note,
  }) => _addShoppingItem(
    householdId: _householdId,
    name: name,
    category: category,
    note: note,
  );

  Future<void> toggleBought(ShoppingItem item) =>
      _toggleItemBought(householdId: _householdId, item: item);

  Future<void> removeItem(String id) =>
      _removeShoppingItem(householdId: _householdId, id: id);

  void search(String query) => emit(state.copyWith(searchQuery: query));

  @override
  Future<void> close() async {
    await _itemsSubscription?.cancel();
    await _catalogSubscription?.cancel();
    return super.close();
  }
}
