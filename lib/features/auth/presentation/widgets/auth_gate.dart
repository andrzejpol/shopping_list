import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shopping_list/features/auth/presentation/cubit/auth_state.dart';
import 'package:shopping_list/features/auth/presentation/pages/login_page.dart';
import 'package:shopping_list/features/household/presentation/widgets/household_gate.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) => switch (state) {
        AuthUnknown() => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        Authenticated(:final user) => HouseholdGate(userId: user.id),
        Unauthenticated() => const LoginPage(),
      },
    );
  }
}
