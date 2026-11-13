import 'package:shopping_list/features/auth/domain/entities/app_user.dart';
import 'package:shopping_list/features/auth/domain/repositories/auth_repository.dart';

class WatchAuthUser {
  final AuthRepository _repository;

  const WatchAuthUser(this._repository);

  Stream<AppUser?> call() => _repository.watchUser();
}
