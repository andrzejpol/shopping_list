import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/core/di/injection.dart';
import 'package:shopping_list/core/failures/data_failure.dart';
import 'package:shopping_list/core/widgets/empty_state_view.dart';
import 'package:shopping_list/features/shopping_list/domain/entities/catalog_product.dart';
import 'package:shopping_list/features/shopping_list/presentation/cubit/catalog_cubit.dart';
import 'package:shopping_list/features/shopping_list/presentation/cubit/catalog_state.dart';
import 'package:shopping_list/features/shopping_list/presentation/widgets/catalog_product_sheet.dart';
import 'package:shopping_list/features/shopping_list/presentation/widgets/catalog_product_tile.dart';

class CatalogPage extends StatelessWidget {
  final String householdId;

  const CatalogPage({super.key, required this.householdId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CatalogCubit>()..init(householdId),
      child: const CatalogView(),
    );
  }
}

class CatalogView extends StatelessWidget {
  const CatalogView({super.key});

  Future<void> _showProductSheet(
    BuildContext context, {
    CatalogProduct? product,
  }) async {
    final cubit = context.read<CatalogCubit>();

    final result = await showModalBottomSheet<({String name, String category})>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => CatalogProductSheet(product: product),
    );

    if (result == null) return;

    if (product == null) {
      await cubit.add(name: result.name, category: result.category);
    } else {
      await cubit.update(
        product.copyWith(name: result.name, category: result.category),
      );
    }
  }

  void _addToShoppingList(BuildContext context, CatalogProduct product) {
    unawaited(context.read<CatalogCubit>().addToShoppingList(product));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('Dodano „${product.name}” do listy')),
      );
  }

  String _failureMessage(DataFailure failure) {
    return switch (failure) {
      PermissionDeniedFailure() =>
        'Nie masz dostępu do produktów tego gospodarstwa.',
      ServiceUnavailableFailure() => 'Nie udało się połączyć z serwerem. Sprawdź internet i spróbuj ponownie.',
      UnknownDataFailure() =>
        'Coś poszło nie tak podczas wczytywania produktów. Spróbuj ponownie.',
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Moje produkty')),
      body: BlocBuilder<CatalogCubit, CatalogState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final failure = state.failure;
          if (failure != null) {
            return EmptyStateView(
              icon: Icons.cloud_off_outlined,
              title: 'Nie udało się wczytać produktów',
              subtitle: _failureMessage(failure),
              actionLabel: 'Spróbuj ponownie',
              onAction: context.read<CatalogCubit>().retry,
            );
          }
          if (state.products.isEmpty) {
            return const EmptyStateView(
              icon: Icons.inventory_2_outlined,
              title: 'Brak produktów',
              subtitle:
                  'Produkty pojawią się tu same, gdy dodasz je do listy '
                  'zakupów. Możesz też dodać je ręcznie.',
            );
          }

          final cubit = context.read<CatalogCubit>();

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
            children: [
              for (final entry in state.groupedProducts.entries) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
                  child: Text(
                    entry.key,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      for (final (index, product) in entry.value.indexed) ...[
                        if (index > 0) const Divider(height: 1, indent: 56),
                        Dismissible(
                          key: ValueKey(product.id),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) => cubit.remove(product),
                          background: Container(
                            color: theme.colorScheme.error,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: Icon(
                              Icons.delete_outline,
                              color: theme.colorScheme.onError,
                            ),
                          ),
                          child: CatalogProductTile(
                            product: product,
                            onTap: () =>
                                _showProductSheet(context, product: product),
                            onTogglePinned: () => cubit.togglePinned(product),
                            onAddToList: () =>
                                _addToShoppingList(context, product),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showProductSheet(context),
        icon: const Icon(Icons.add),
        label: const Text('Dodaj produkt'),
      ),
    );
  }
}
