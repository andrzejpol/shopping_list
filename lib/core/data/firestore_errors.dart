import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_list/core/failures/data_failure.dart';

DataFailure mapFirestoreError(Object error) {
  if (error is! FirebaseException) return const UnknownDataFailure();

  return switch (error.code) {
    'permission-denied' => const PermissionDeniedFailure(),
    'unavailable' => const ServiceUnavailableFailure(),
    _ => const UnknownDataFailure(),
  };
}

extension FirestoreStreamErrors<T> on Stream<T> {
  Stream<T> mapFirestoreErrors() {
    return handleError((Object error) => throw mapFirestoreError(error));
  }
}
