import 'package:shopping_list/features/shopping_list/domain/entities/catalog_product.dart';
import 'package:shopping_list/features/shopping_list/domain/repositories/catalog_repository.dart';

class UpdateCatalogProduct {
  final CatalogRepository _repository;

  const UpdateCatalogProduct(this._repository);

  Future<void> call({
    required String householdId,
    required CatalogProduct product,
  }) async {
    final trimmedName = product.name.trim();
    final trimmedCategory = product.category.trim();

    if (trimmedName.isEmpty) return;

    await _repository.updateProduct(
      householdId: householdId,
      product: product.copyWith(name: trimmedName, category: trimmedCategory),
    );
  }
}
