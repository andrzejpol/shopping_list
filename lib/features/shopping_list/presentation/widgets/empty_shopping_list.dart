import 'package:flutter/material.dart';
import 'package:shopping_list/core/widgets/empty_state_view.dart';

class EmptyShoppingList extends StatelessWidget {
  const EmptyShoppingList({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyStateView(
      icon: Icons.shopping_cart_outlined,
      title: 'Lista jest pusta',
      subtitle: 'Dodaj pierwszy produkt przyciskiem „Dodaj” na dole ekranu.',
    );
  }
}
