import 'package:shopping_list/features/shopping_list/domain/repositories/catalog_repository.dart';
import 'package:shopping_list/features/shopping_list/domain/repositories/shopping_list_repository.dart';

class AddShoppingItem {
  final ShoppingListRepository _shoppingListRepository;
  final CatalogRepository _catalogRepository;

  const AddShoppingItem(this._shoppingListRepository, this._catalogRepository);

  Future<void> call({
    required String householdId,
    required String name,
    required String category,
    String? note,
  }) async {
    final trimmedName = name.trim();
    final trimmedCategory = category.trim();
    final trimmedNote = note?.trim();
    final normalizedNote = trimmedNote == null || trimmedNote.isEmpty
        ? null
        : trimmedNote;

    if (trimmedName.isEmpty) return;

    await Future.wait([
      _shoppingListRepository.addItem(
        householdId: householdId,
        name: trimmedName,
        category: trimmedCategory,
        note: normalizedNote,
      ),
      _catalogRepository.recordUsage(
        householdId: householdId,
        name: trimmedName,
        category: trimmedCategory,
      ),
    ]);
  }
}
