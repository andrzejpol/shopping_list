import 'package:shopping_list/features/auth/domain/failures/auth_failure.dart';
import 'package:shopping_list/features/auth/domain/repositories/auth_repository.dart';

class SignUp {
  final AuthRepository _repository;

  const SignUp(this._repository);

  Future<void> call({required String email, required String password}) async {
    final trimmedEmail = email.trim();
    if (password.length < 6) throw const WeakPassword();
    await _repository.signUp(email: trimmedEmail, password: password);
  }
}
