import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shopping_list/features/auth/domain/entities/app_user.dart';
import 'package:shopping_list/features/auth/domain/failures/auth_failure.dart';
import 'package:shopping_list/features/auth/domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth;

  FirebaseAuthRepository(this._auth);

  @override
  Stream<AppUser?> watchUser() {
    return _auth.authStateChanges().map(_toAppUser);
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> signUp({required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> signOut() => _auth.signOut();

  AppUser? _toAppUser(User? user) {
    if (user == null) return null;
    return AppUser(id: user.uid, email: user.email ?? '');
  }

  AuthFailure _mapError(FirebaseAuthException e) {
    return switch (e.code) {
      'invalid-credential' ||
      'wrong-password' ||
      'user-not-found' => const InvalidCredentials(),
      'email-already-in-use' => const EmailAlreadyInUse(),
      'weak-password' => const WeakPassword(),
      'invalid-email' => const InvalidEmail(),
      'network-request-failed' => const NetworkFailure(),
      'too-many-requests' => const TooManyRequests(),
      'popup-closed-by-user' ||
      'cancelled-popup-request' ||
      'web-context-canceled' => const SignInCancelled(),
      'popup-blocked' => const PopupBlocked(),
      'account-exists-with-different-credential' =>
        const AccountExistsWithDifferentCredential(),
      _ => const UnknownAuthFailure(),
    };
  }

  @override
  Future<void> signInWithGoogle() async {
    final provider = GoogleAuthProvider()
      ..setCustomParameters({'prompt': 'select_account'});

    try {
      if (kIsWeb) {
        await _auth.signInWithPopup(provider);
      } else {
        await _auth.signInWithProvider(provider);
      }
    } on FirebaseAuthException catch (e) {
      throw _mapError(e);
    }
  }
}
