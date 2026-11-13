import 'package:shopping_list/features/shopping_list/domain/entities/shopping_item.dart';
import 'package:shopping_list/features/shopping_list/domain/repositories/shopping_list_repository.dart';

class WatchShoppingItems {
  final ShoppingListRepository _repository;

  const WatchShoppingItems(this._repository);

  Stream<List<ShoppingItem>> call(String householdId) =>
      _repository.watchItems(householdId);
}
