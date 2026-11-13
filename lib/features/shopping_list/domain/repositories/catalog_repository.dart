import 'package:shopping_list/features/shopping_list/domain/entities/catalog_product.dart';

abstract interface class CatalogRepository {
  Stream<List<CatalogProduct>> watchProducts(String householdId);

  Future<void> recordUsage({
    required String householdId,
    required String name,
    required String category,
  });

  Future<void> addProduct({
    required String householdId,
    required String name,
    required String category,
    required bool isPinned,
  });

  Future<void> updateProduct({
    required String householdId,
    required CatalogProduct product,
  });

  Future<void> removeProduct({required String householdId, required String id});
}
