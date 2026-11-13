import 'package:shopping_list/features/shopping_list/domain/repositories/catalog_repository.dart';

class AddCatalogProduct {
  final CatalogRepository _repository;

  const AddCatalogProduct(this._repository);

  Future<void> call({
    required String householdId,
    required String name,
    required String category,
  }) async {
    final trimmedName = name.trim();
    final trimmedCategory = category.trim();

    if (trimmedName.isEmpty) return;

    await _repository.addProduct(
      householdId: householdId,
      name: trimmedName,
      category: trimmedCategory,
      isPinned: true,
    );
  }
}
