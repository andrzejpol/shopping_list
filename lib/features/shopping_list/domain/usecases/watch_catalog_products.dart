import 'package:shopping_list/features/shopping_list/domain/entities/catalog_product.dart';
import 'package:shopping_list/features/shopping_list/domain/repositories/catalog_repository.dart';

class WatchCatalogProducts {
  final CatalogRepository _repository;

  const WatchCatalogProducts(this._repository);

  Stream<List<CatalogProduct>> call(String householdId) =>
      _repository.watchProducts(householdId);
}
