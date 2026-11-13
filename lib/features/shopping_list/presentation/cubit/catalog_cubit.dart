import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/core/failures/data_failure.dart';
import 'package:shopping_list/features/shopping_list/domain/entities/catalog_product.dart';
import 'package:shopping_list/features/shopping_list/domain/usecases/add_catalog_product.dart';
import 'package:shopping_list/features/shopping_list/domain/usecases/add_shopping_item.dart';
import 'package:shopping_list/features/shopping_list/domain/usecases/remove_catalog_product.dart';
import 'package:shopping_list/features/shopping_list/domain/usecases/toggle_product_pinned.dart';
import 'package:shopping_list/features/shopping_list/domain/usecases/update_catalog_product.dart';
import 'package:shopping_list/features/shopping_list/domain/usecases/watch_catalog_products.dart';
import 'package:shopping_list/features/shopping_list/presentation/cubit/catalog_state.dart';

class CatalogCubit extends Cubit<CatalogState> {
  CatalogCubit({
    required WatchCatalogProducts watchCatalogProducts,
    required AddCatalogProduct addCatalogProduct,
    required UpdateCatalogProduct updateCatalogProduct,
    required ToggleProductPinned toggleProductPinned,
    required RemoveCatalogProduct removeCatalogProduct,
    required AddShoppingItem addShoppingItem,
  }) : _watchCatalogProducts = watchCatalogProducts,
       _addCatalogProduct = addCatalogProduct,
       _updateCatalogProduct = updateCatalogProduct,
       _toggleProductPinned = toggleProductPinned,
       _removeCatalogProduct = removeCatalogProduct,
       _addShoppingItem = addShoppingItem,
       super(const CatalogState());

  final WatchCatalogProducts _watchCatalogProducts;
  final AddCatalogProduct _addCatalogProduct;
  final UpdateCatalogProduct _updateCatalogProduct;
  final ToggleProductPinned _toggleProductPinned;
  final RemoveCatalogProduct _removeCatalogProduct;
  final AddShoppingItem _addShoppingItem;

  late final String _householdId;
  StreamSubscription<List<CatalogProduct>>? _subscription;

  void init(String householdId) {
    _householdId = householdId;
    _subscribe();
  }

  void _subscribe() {
    _subscription = _watchCatalogProducts(_householdId).listen(
      (products) => emit(CatalogState(products: products, isLoading: false)),
      onError: (Object error) => emit(
        CatalogState(
          isLoading: false,
          failure: error is DataFailure ? error : const UnknownDataFailure(),
        ),
      ),
    );
  }

  Future<void> add({required String name, required String category}) =>
      _addCatalogProduct(
        householdId: _householdId,
        name: name,
        category: category,
      );

  Future<void> update(CatalogProduct product) =>
      _updateCatalogProduct(householdId: _householdId, product: product);

  Future<void> togglePinned(CatalogProduct product) =>
      _toggleProductPinned(householdId: _householdId, product: product);

  Future<void> remove(CatalogProduct product) =>
      _removeCatalogProduct(householdId: _householdId, id: product.id);

  Future<void> addToShoppingList(CatalogProduct product) => _addShoppingItem(
    householdId: _householdId,
    name: product.name,
    category: product.category,
  );

  Future<void> retry() async {
    await _subscription?.cancel();
    emit(const CatalogState());
    _subscribe();
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
