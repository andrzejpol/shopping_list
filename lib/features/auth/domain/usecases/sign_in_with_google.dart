import 'package:shopping_list/features/auth/domain/repositories/auth_repository.dart';

class SignInWithGoogle {
  final AuthRepository _repository;

  const SignInWithGoogle(this._repository);

  Future<void> call() => _repository.signInWithGoogle();
}
