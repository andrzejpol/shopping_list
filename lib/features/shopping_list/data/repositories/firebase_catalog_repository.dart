import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_list/core/data/firestore_errors.dart';
import 'package:shopping_list/features/shopping_list/data/mappers/catalog_product_mapper.dart';
import 'package:shopping_list/features/shopping_list/domain/catalog_key.dart';
import 'package:shopping_list/features/shopping_list/domain/entities/catalog_product.dart';
import 'package:shopping_list/features/shopping_list/domain/repositories/catalog_repository.dart';

class FirebaseCatalogRepository implements CatalogRepository {
  final FirebaseFirestore _firestore;

  FirebaseCatalogRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> _catalog(String householdId) =>
      _firestore
          .collection('households')
          .doc(householdId)
          .collection('catalog');

  @override
  Stream<List<CatalogProduct>> watchProducts(String householdId) {
    return _catalog(householdId)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(CatalogProductMapper.fromFirestore).toList(),
        )
        .mapFirestoreErrors();
  }

  @override
  Future<void> recordUsage({
    required String householdId,
    required String name,
    required String category,
  }) async {
    await _catalog(householdId).doc(catalogKeyFor(name)).set({
      'name': name,
      'category': category,
      'useCount': FieldValue.increment(1),
      'lastUsedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<void> addProduct({
    required String householdId,
    required String name,
    required String category,
    required bool isPinned,
  }) async {
    await _catalog(householdId).doc(catalogKeyFor(name)).set({
      'name': name,
      'category': category,
      'isPinned': isPinned,
    }, SetOptions(merge: true));
  }

  @override
  Future<void> updateProduct({
    required String householdId,
    required CatalogProduct product,
  }) async {
    final catalog = _catalog(householdId);
    final newKey = catalogKeyFor(product.name);
    final data = CatalogProductMapper.toFirestore(product);

    if (newKey == product.id) {
      await catalog.doc(product.id).set(data, SetOptions(merge: true));
      return;
    }

    final batch = _firestore.batch();
    batch.delete(catalog.doc(product.id));
    batch.set(catalog.doc(newKey), data, SetOptions(merge: true));
    await batch.commit();
  }

  @override
  Future<void> removeProduct({
    required String householdId,
    required String id,
  }) async {
    await _catalog(householdId).doc(id).delete();
  }
}
