import 'package:shopping_list/features/shopping_list/domain/entities/catalog_product.dart';
import 'package:shopping_list/features/shopping_list/domain/repositories/catalog_repository.dart';

class ToggleProductPinned {
  final CatalogRepository _repository;

  const ToggleProductPinned(this._repository);

  Future<void> call({
    required String householdId,
    required CatalogProduct product,
  }) {
    return _repository.updateProduct(
      householdId: householdId,
      product: product.copyWith(isPinned: !product.isPinned),
    );
  }
}
