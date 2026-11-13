import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_list/core/data/firestore_errors.dart';
import 'package:shopping_list/features/shopping_list/data/mappers/shopping_item_mapper.dart';
import 'package:shopping_list/features/shopping_list/domain/entities/shopping_item.dart';
import 'package:shopping_list/features/shopping_list/domain/repositories/shopping_list_repository.dart';

class FirebaseShoppingListRepository implements ShoppingListRepository {
  final FirebaseFirestore _firestore;

  FirebaseShoppingListRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> _items(String householdId) =>
      _firestore.collection('households').doc(householdId).collection('items');

  @override
  Stream<List<ShoppingItem>> watchItems(String householdId) {
    return _items(householdId)
        .orderBy('createdAt')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(ShoppingItemMapper.fromFirestore).toList(),
        )
        .mapFirestoreErrors();
  }

  @override
  Future<void> addItem({
    required String householdId,
    required String name,
    required String category,
    String? note,
  }) async {
    await _items(householdId).add({
      'name': name,
      'category': category,
      'isBought': false,
      'note': note,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> updateItem({
    required String householdId,
    required ShoppingItem item,
  }) async {
    await _items(householdId)
        .doc(item.id)
        .update(ShoppingItemMapper.toFirestore(item));
  }

  @override
  Future<void> removeItem({
    required String householdId,
    required String id,
  }) async {
    await _items(householdId).doc(id).delete();
  }
}
