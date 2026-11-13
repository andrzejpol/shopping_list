import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_list/features/shopping_list/domain/entities/catalog_product.dart';

abstract final class CatalogProductMapper {
  static CatalogProduct fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    return CatalogProduct(
      id: doc.id,
      name: data['name'] as String,
      category: data['category'] as String,
      useCount: (data['useCount'] as num?)?.toInt() ?? 0,
      isPinned: data['isPinned'] as bool? ?? false,
    );
  }

  static Map<String, dynamic> toFirestore(CatalogProduct product) {
    return {
      'name': product.name,
      'category': product.category,
      'useCount': product.useCount,
      'isPinned': product.isPinned,
    };
  }
}
