import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/features/auth/domain/failures/auth_failure.dart';
import 'package:shopping_list/features/auth/domain/usecases/sign_in.dart';
import 'package:shopping_list/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:shopping_list/features/auth/domain/usecases/sign_up.dart';
import 'package:shopping_list/features/auth/presentation/cubit/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required SignIn signIn,
    required SignUp signUp,
    required SignInWithGoogle signInWithGoogle,
  }) : _signIn = signIn,
       _signUp = signUp,
       _signInWithGoogle = signInWithGoogle,
       super(const LoginState());

  final SignIn _signIn;
  final SignUp _signUp;
  final SignInWithGoogle _signInWithGoogle;

  Future<void> signIn({required String email, required String password}) =>
      _submit(() => _signIn(email: email, password: password));

  Future<void> signUp({required String email, required String password}) =>
      _submit(() => _signUp(email: email, password: password));

  Future<void> signInWithGoogle() => _submit(_signInWithGoogle.call);

  Future<void> _submit(Future<void> Function() action) async {
    emit(const LoginState(isSubmitting: true));
    try {
      await action();
    } on SignInCancelled {
      emit(const LoginState());
    } on AuthFailure catch (failure) {
      emit(LoginState(failure: failure));
    }
  }
}
