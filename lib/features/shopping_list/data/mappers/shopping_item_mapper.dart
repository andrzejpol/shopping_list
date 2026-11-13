import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_list/features/shopping_list/domain/entities/shopping_item.dart';

abstract final class ShoppingItemMapper {
  static ShoppingItem fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    return ShoppingItem(
      id: doc.id,
      name: data['name'] as String,
      category: data['category'] as String,
      isBought: data['isBought'] as bool? ?? false,
      note: data['note'] as String?,
    );
  }

  static Map<String, dynamic> toFirestore(ShoppingItem item) {
    return {
      'name': item.name,
      'category': item.category,
      'isBought': item.isBought,
      'note': item.note,
    };
  }
}
