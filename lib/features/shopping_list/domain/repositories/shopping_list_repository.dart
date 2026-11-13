import 'package:shopping_list/features/shopping_list/domain/entities/shopping_item.dart';

abstract interface class ShoppingListRepository {
  Stream<List<ShoppingItem>> watchItems(String householdId);

  Future<void> addItem({
    required String householdId,
    required String name,
    required String category,
    String? note,
  });

  Future<void> updateItem({
    required String householdId,
    required ShoppingItem item,
  });

  Future<void> removeItem({required String householdId, required String id});
}
