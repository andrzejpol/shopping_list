import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/core/di/injection.dart';
import 'package:shopping_list/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shopping_list/features/household/domain/failures/household_failure.dart';
import 'package:shopping_list/features/household/domain/household_code.dart';
import 'package:shopping_list/features/household/presentation/cubit/household_setup_cubit.dart';
import 'package:shopping_list/features/household/presentation/cubit/household_setup_state.dart';

class HouseholdSetupPage extends StatelessWidget {
  final String userId;

  const HouseholdSetupPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HouseholdSetupCubit>(),
      child: HouseholdSetupView(userId: userId),
    );
  }
}

class HouseholdSetupView extends StatefulWidget {
  final String userId;

  const HouseholdSetupView({super.key, required this.userId});

  @override
  State<HouseholdSetupView> createState() => _HouseholdSetupViewState();
}

class _HouseholdSetupViewState extends State<HouseholdSetupView> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  String _messageFor(HouseholdFailure failure) {
    return switch (failure) {
      InvalidHouseholdCode() =>
        'Kod musi mieć $householdCodeLength znaków. Sprawdź, czy przepisałeś go w całości.',
      HouseholdNotFound() =>
        'Nie ma gospodarstwa o takim kodzie. Sprawdź, czy nie ma literówki.',
      UnknownHouseholdFailure() => 'Coś poszło nie tak. Sprawdź połączenie z internetem i spróbuj ponownie.',
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Twoje gospodarstwo'),
        actions: [
          IconButton(
            onPressed: () => context.read<AuthCubit>().signOut(),
            icon: const Icon(Icons.logout),
            tooltip: 'Wyloguj',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: BlocBuilder<HouseholdSetupCubit, HouseholdSetupState>(
            builder: (context, state) {
              final failure = state.failure;
              final cubit = context.read<HouseholdSetupCubit>();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 16,
                children: [
                  Text(
                    'Załóż nową listę zakupów i zaproś do niej bliskich.',
                    style: theme.textTheme.titleMedium,
                  ),
                  FilledButton.icon(
                    onPressed: state.isSubmitting
                        ? null
                        : () => cubit.create(widget.userId),
                    icon: const Icon(Icons.add_home_outlined),
                    label: const Text('Utwórz gospodarstwo'),
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
                  Text(
                    'Masz kod od kogoś bliskiego? Dołącz do jego listy.',
                    style: theme.textTheme.titleMedium,
                  ),
                  TextField(
                    controller: _codeController,
                    textCapitalization: TextCapitalization.characters,
                    maxLength: householdCodeLength,
                    decoration: const InputDecoration(
                      labelText: 'Kod zaproszenia',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: state.isSubmitting
                        ? null
                        : () => cubit.join(
                            userId: widget.userId,
                            code: _codeController.text,
                          ),
                    child: const Text('Dołącz'),
                  ),
                  if (failure != null)
                    Text(
                      _messageFor(failure),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  if (state.isSubmitting)
                    const Center(child: CircularProgressIndicator()),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
