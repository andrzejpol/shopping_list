import 'dart:async';

import 'package:shopping_list/features/shopping_list/domain/entities/shopping_item.dart';
import 'package:shopping_list/features/shopping_list/domain/repositories/shopping_list_repository.dart';

class InMemoryListRepository implements ShoppingListRepository {
  final _items = <ShoppingItem>[
    const ShoppingItem(id: '1', name: 'Pomarańcze', category: 'Owoce'),
    const ShoppingItem(
      id: '2',
      name: 'Banany',
      category: 'Owoce',
      isBought: true,
    ),
    const ShoppingItem(id: '3', name: 'Chleb', category: 'Pieczywo'),
    const ShoppingItem(id: '4', name: 'Mleko', category: 'Nabiał'),
  ];

  final _controller = StreamController<List<ShoppingItem>>.broadcast();

  void _notifyListeners() {
    _controller.add(List.unmodifiable(_items));
  }

  @override
  Stream<List<ShoppingItem>> watchItems(String householdId) async* {
    yield List.unmodifiable(_items);
    yield* _controller.stream;
  }

  @override
  Future<void> addItem({
    required String householdId,
    required String name,
    required String category,
    String? note,
  }) async {
    final newItem = ShoppingItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      note: note,
      category: category,
    );
    _items.add(newItem);
    _notifyListeners();
  }

  @override
  Future<void> updateItem({
    required String householdId,
    required ShoppingItem item,
  }) async {
    final index = _items.indexWhere((e) => e.id == item.id);
    if (index == -1) return;

    _items[index] = item;
    _notifyListeners();
  }

  @override
  Future<void> removeItem({
    required String householdId,
    required String id,
  }) async {
    _items.removeWhere((item) => item.id == id);
    _notifyListeners();
  }
}
