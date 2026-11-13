import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/core/di/injection.dart';
import 'package:shopping_list/core/widgets/empty_state_view.dart';
import 'package:shopping_list/features/household/presentation/cubit/household_cubit.dart';
import 'package:shopping_list/features/household/presentation/cubit/household_state.dart';
import 'package:shopping_list/features/household/presentation/pages/household_setup_page.dart';
import 'package:shopping_list/features/shopping_list/presentation/pages/shopping_list_page.dart';

class HouseholdGate extends StatelessWidget {
  final String userId;

  const HouseholdGate({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HouseholdCubit>()..init(userId),
      child: BlocBuilder<HouseholdCubit, HouseholdState>(
        builder: (context, state) => switch (state) {
          HouseholdError() => Scaffold(
            body: EmptyStateView(
              icon: Icons.cloud_off_outlined,
              title: 'Nie udało się wczytać gospodarstwa',
              subtitle: 'Sprawdź połączenie z internetem i spróbuj ponownie.',
              actionLabel: 'Spróbuj ponownie',
              onAction: context.read<HouseholdCubit>().retry,
            ),
          ),
          HouseholdUnknown() => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          HouseholdMissing() => HouseholdSetupPage(userId: userId),
          HouseholdReady(:final householdId) => ShoppingListPage(
            householdId: householdId,
          ),
        },
      ),
    );
  }
}
