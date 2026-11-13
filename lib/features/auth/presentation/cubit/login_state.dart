import 'package:equatable/equatable.dart';
import 'package:shopping_list/features/auth/domain/failures/auth_failure.dart';

class LoginState extends Equatable {
  final bool isSubmitting;
  final AuthFailure? failure;

  const LoginState({this.isSubmitting = false, this.failure});

  @override
  List<Object?> get props => [isSubmitting, failure];
}
