import 'package:shopping_list/features/shopping_list/domain/entities/shopping_item.dart';
import 'package:shopping_list/features/shopping_list/domain/repositories/shopping_list_repository.dart';

class ToggleItemBought {
  final ShoppingListRepository _repository;

  const ToggleItemBought(this._repository);

  Future<void> call({required String householdId, required ShoppingItem item}) {
    return _repository.updateItem(
      householdId: householdId,
      item: item.copyWith(isBought: !item.isBought),
    );
  }
}
