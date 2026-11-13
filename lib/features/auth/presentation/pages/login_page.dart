import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/core/di/injection.dart';
import 'package:shopping_list/core/widgets/error_banner.dart';
import 'package:shopping_list/features/auth/domain/failures/auth_failure.dart';
import 'package:shopping_list/features/auth/presentation/cubit/login_cubit.dart';
import 'package:shopping_list/features/auth/presentation/cubit/login_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginCubit>(),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isRegister = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<LoginCubit>();
    final email = _emailController.text;
    final password = _passwordController.text;

    if (_isRegister) {
      cubit.signUp(email: email, password: password);
    } else {
      cubit.signIn(email: email, password: password);
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Podaj adres e-mail';
    if (!value.contains('@')) return 'To nie wygląda na adres e-mail';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Podaj hasło';
    return null;
  }

  String _messageFor(AuthFailure failure) {
    return switch (failure) {
      InvalidCredentials() => 'Nieprawidłowy e-mail lub hasło.',
      EmailAlreadyInUse() => 'Konto z tym adresem już istnieje. Zaloguj się.',
      WeakPassword() => 'Hasło musi zawierać co najmniej 6 znaków.',
      InvalidEmail() => 'Nieprawidłowy adres e-mail.',
      NetworkFailure() => 'Brak połączenia z internetem. Spróbuj ponownie.',
      TooManyRequests() =>
        'Zbyt wiele prób. Odczekaj chwilę i spróbuj ponownie.',
      UnknownAuthFailure() => 'Coś poszło nie tak. Spróbuj ponownie.',
      SignInCancelled() => 'Logowanie zostało anulowane.',
      PopupBlocked() => 'Przeglądarka zablokowała okno logowania. Zezwól na wyskakujące okna i spróbuj ponownie.',
      AccountExistsWithDifferentCredential() =>
        'Konto z tym adresem już istnieje. Zaloguj się e-mailem i hasłem.',
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  final failure = state.failure;

                  return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 16,
                      children: [
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.shopping_cart_outlined,
                              size: 40,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                        Column(
                          spacing: 4,
                          children: [
                            Text(
                              _isRegister ? 'Załóż konto' : 'Witaj ponownie',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Wspólna lista zakupów dla całej rodziny',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'E-mail',
                            prefixIcon: Icon(Icons.mail_outline),
                          ),
                          validator: _validateEmail,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          autofillHints: const [AutofillHints.password],
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText: 'Hasło',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              tooltip: _obscurePassword
                                  ? 'Pokaż hasło'
                                  : 'Ukryj hasło',
                            ),
                          ),
                          validator: _validatePassword,
                          onFieldSubmitted: (_) => _submit(),
                        ),
                        if (failure != null)
                          ErrorBanner(message: _messageFor(failure)),
                        FilledButton(
                          onPressed: state.isSubmitting ? null : _submit,
                          child: state.isSubmitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  _isRegister
                                      ? 'Zarejestruj się'
                                      : 'Zaloguj się',
                                ),
                        ),
                        const Row(
                          children: [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text('albo'),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                        OutlinedButton.icon(
                          onPressed: state.isSubmitting
                              ? null
                              : () => context
                                    .read<LoginCubit>()
                                    .signInWithGoogle(),
                          icon: const Icon(Icons.account_circle_outlined),
                          label: const Text('Kontynuuj z kontem Google'),
                        ),
                        TextButton(
                          onPressed: state.isSubmitting
                              ? null
                              : () =>
                                    setState(() => _isRegister = !_isRegister),
                          child: Text(
                            _isRegister
                                ? 'Masz już konto? Zaloguj się'
                                : 'Nie masz konta? Zarejestruj się',
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
