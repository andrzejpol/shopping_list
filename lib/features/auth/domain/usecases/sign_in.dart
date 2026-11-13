import 'package:shopping_list/features/auth/domain/repositories/auth_repository.dart';

class SignIn {
  final AuthRepository _repository;

  const SignIn(this._repository);

  Future<void> call({required String email, required String password}) async {
    final trimmedEmail = email.trim();

    await _repository.signIn(email: trimmedEmail, password: password);
  }
}
