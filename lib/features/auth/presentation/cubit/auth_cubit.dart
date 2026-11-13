import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/features/auth/domain/entities/app_user.dart';
import 'package:shopping_list/features/auth/domain/usecases/sign_out.dart';
import 'package:shopping_list/features/auth/domain/usecases/watch_auth_user.dart';
import 'package:shopping_list/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required WatchAuthUser watchAuthUser, required SignOut signOut})
    : _watchAuthUser = watchAuthUser,
      _signOut = signOut,
      super(const AuthUnknown());

  final WatchAuthUser _watchAuthUser;
  final SignOut _signOut;

  StreamSubscription<AppUser?>? _subscription;

  void init() {
    _subscription = _watchAuthUser().listen((user) {
      emit(user == null ? const Unauthenticated() : Authenticated(user));
    });
  }

  Future<void> signOut() => _signOut();

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
