import 'package:shopping_list/features/shopping_list/domain/repositories/catalog_repository.dart';

class RemoveCatalogProduct {
  final CatalogRepository _repository;

  const RemoveCatalogProduct(this._repository);

  Future<void> call({required String householdId, required String id}) async {
    if (id.isEmpty) return;

    await _repository.removeProduct(householdId: householdId, id: id);
  }
}
