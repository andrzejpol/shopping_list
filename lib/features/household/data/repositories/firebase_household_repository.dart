import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_list/core/data/firestore_errors.dart';
import 'package:shopping_list/features/household/domain/failures/household_failure.dart';
import 'package:shopping_list/features/household/domain/household_code.dart';
import 'package:shopping_list/features/household/domain/repositories/household_repository.dart';

class FirebaseHouseholdRepository implements HouseholdRepository {
  final FirebaseFirestore _firestore;
  final _random = Random.secure();

  FirebaseHouseholdRepository(this._firestore);

  static const _codeAlphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  CollectionReference<Map<String, dynamic>> get _households =>
      _firestore.collection('households');

  @override
  Stream<String?> watchHouseholdId(String userId) {
    return _users
        .doc(userId)
        .snapshots(includeMetadataChanges: true)
        .where((doc) => !doc.metadata.hasPendingWrites)
        .map((doc) => doc.data()?['householdId'] as String?)
        .distinct()
        .mapFirestoreErrors();
  }

  @override
  Future<String> createHousehold(String userId) async {
    try {
      final code = await _generateUniqueCode();

      final batch = _firestore.batch();
      batch.set(_households.doc(code), {
        'memberIds': [userId],
        'createdAt': FieldValue.serverTimestamp(),
      });
      batch.set(_users.doc(userId), {
        'householdId': code,
      }, SetOptions(merge: true));
      await batch.commit();

      return code;
    } on FirebaseException {
      throw const UnknownHouseholdFailure();
    }
  }

  @override
  Future<void> joinHousehold({
    required String userId,
    required String code,
  }) async {
    try {
      final householdRef = _households.doc(code);
      final household = await householdRef.get();
      if (!household.exists) throw const HouseholdNotFound();

      final batch = _firestore.batch();
      batch.update(householdRef, {
        'memberIds': FieldValue.arrayUnion([userId]),
      });
      batch.set(_users.doc(userId), {
        'householdId': code,
      }, SetOptions(merge: true));
      await batch.commit();
    } on FirebaseException {
      throw const UnknownHouseholdFailure();
    }
  }

  Future<String> _generateUniqueCode() async {
    while (true) {
      final code = _randomCode();
      final existing = await _households.doc(code).get();
      if (!existing.exists) return code;
    }
  }

  String _randomCode() {
    return List.generate(
      householdCodeLength,
      (_) => _codeAlphabet[_random.nextInt(_codeAlphabet.length)],
    ).join();
  }
}
