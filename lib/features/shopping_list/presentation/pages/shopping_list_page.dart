import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/core/di/injection.dart';
import 'package:shopping_list/core/failures/data_failure.dart';
import 'package:shopping_list/core/widgets/empty_state_view.dart';
import 'package:shopping_list/core/widgets/refresh_on_resume.dart';
import 'package:shopping_list/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shopping_list/features/shopping_list/presentation/cubit/shopping_list_cubit.dart';
import 'package:shopping_list/features/shopping_list/presentation/cubit/shopping_list_state.dart';
import 'package:shopping_list/features/shopping_list/presentation/pages/catalog_page.dart';
import 'package:shopping_list/features/shopping_list/presentation/widgets/add_item_sheet.dart';
import 'package:shopping_list/features/shopping_list/presentation/widgets/category_section.dart';
import 'package:shopping_list/features/shopping_list/presentation/widgets/empty_shopping_list.dart';
import 'package:shopping_list/features/shopping_list/presentation/widgets/shopping_summary.dart';

class ShoppingListPage extends StatelessWidget {
  final String householdId;

  const ShoppingListPage({super.key, required this.householdId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ShoppingListCubit>()..init(householdId),
      child: ShoppingListView(householdId: householdId),
    );
  }
}

class ShoppingListView extends StatelessWidget {
  final String householdId;

  const ShoppingListView({super.key, required this.householdId});

  Future<void> _showAddItemSheet(BuildContext context) async {
    final cubit = context.read<ShoppingListCubit>();
    final suggestions = cubit.state.suggestions;

    final result =
        await showModalBottomSheet<
          ({String name, String category, String? note})
        >(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (_) => AddItemSheet(suggestions: suggestions),
        );

    if (result == null) return;
    await cubit.addItem(
      name: result.name,
      category: result.category,
      note: result.note,
    );
  }

  String _failureMessage(DataFailure failure) {
    return switch (failure) {
      PermissionDeniedFailure() => 'Nie masz dostępu do tej listy. Spróbuj wylogować się i zalogować ponownie.',
      ServiceUnavailableFailure() => 'Nie udało się połączyć z serwerem. Sprawdź internet i spróbuj ponownie.',
      UnknownDataFailure() =>
        'Coś poszło nie tak podczas wczytywania listy. Spróbuj ponownie.',
    };
  }

  Future<void> _showInviteDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);

        return AlertDialog(
          title: const Text('Zaproś do listy'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              const Text(
                'Podaj ten kod osobie, z którą chcesz dzielić listę. '
                'Niech wybierze „Dołącz” po rejestracji.',
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SelectableText(
                  householdId,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    letterSpacing: 6,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Zamknij'),
            ),
            FilledButton.icon(
              onPressed: () async {
                final navigator = Navigator.of(dialogContext);
                final messenger = ScaffoldMessenger.of(context);

                await Clipboard.setData(ClipboardData(text: householdId));

                navigator.pop();
                messenger.showSnackBar(
                  const SnackBar(content: Text('Kod skopiowany')),
                );
              },
              icon: const Icon(Icons.copy),
              label: const Text('Kopiuj'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshOnResume(
      onResume: context.read<ShoppingListCubit>().refresh,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lista zakupów'),
          actions: [
            IconButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CatalogPage(householdId: householdId),
                ),
              ),
              icon: const Icon(Icons.inventory_2_outlined),
              tooltip: 'Moje produkty',
            ),
            IconButton(
              onPressed: () => _showInviteDialog(context),
              icon: const Icon(Icons.person_add_alt),
              tooltip: 'Zaproś',
            ),
            IconButton(
              onPressed: () => context.read<AuthCubit>().signOut(),
              icon: const Icon(Icons.logout),
              tooltip: 'Wyloguj',
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: SearchBar(
                hintText: 'Szukaj produktu',
                leading: const Icon(Icons.search),
                onChanged: (query) =>
                    context.read<ShoppingListCubit>().search(query),
              ),
            ),
            Expanded(
              child: BlocBuilder<ShoppingListCubit, ShoppingListState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final failure = state.failure;
                  if (failure != null) {
                    return EmptyStateView(
                      icon: Icons.cloud_off_outlined,
                      title: 'Nie udało się wczytać listy',
                      subtitle: _failureMessage(failure),
                      actionLabel: 'Spróbuj ponownie',
                      onAction: context.read<ShoppingListCubit>().retry,
                    );
                  }

                  if (state.items.isEmpty) {
                    return const EmptyShoppingList();
                  }

                  final visibleItems = state.visibleItems;
                  if (visibleItems.isEmpty) {
                    return EmptyStateView(
                      icon: Icons.search_off,
                      title: 'Brak wyników',
                      subtitle:
                          'Nie znaleziono produktów pasujących do „${state.searchQuery}”.',
                    );
                  }

                  final groups = state.groupedVisibleItems;
                  final cubit = context.read<ShoppingListCubit>();

                  return RefreshIndicator(
                    onRefresh: cubit.refresh,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                      children: [
                        ShoppingSummary(
                          boughtCount: state.boughtCount,
                          totalCount: state.items.length,
                        ),
                        for (final entry in groups.entries)
                          CategorySection(
                            category: entry.key,
                            items: entry.value,
                            onToggle: cubit.toggleBought,
                            onRemove: (item) => cubit.removeItem(item.id),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAddItemSheet(context),
          icon: const Icon(Icons.add),
          label: const Text('Dodaj'),
        ),
      ),
    );
  }
}
