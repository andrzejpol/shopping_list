import 'package:shopping_list/features/shopping_list/domain/repositories/shopping_list_repository.dart';

class RemoveShoppingItem {
  final ShoppingListRepository _repository;

  const RemoveShoppingItem(this._repository);

  Future<void> call({required String householdId, required String id}) async {
    if (id.isEmpty) return;

    await _repository.removeItem(householdId: householdId, id: id);
  }
}
