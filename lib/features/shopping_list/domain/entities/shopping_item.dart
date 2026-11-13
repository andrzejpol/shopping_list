import 'package:equatable/equatable.dart';

class ShoppingItem extends Equatable {
  final String id;
  final String name;
  final bool isBought;
  final String category;
  final String? note;

  const ShoppingItem({
    required this.id,
    required this.name,
    required this.category,
    this.isBought = false,
    this.note,
  });

  ShoppingItem copyWith({
    String? name,
    bool? isBought,
    String? category,
    String? note,
  }) {
    return ShoppingItem(
      id: id,
      name: name ?? this.name,
      isBought: isBought ?? this.isBought,
      category: category ?? this.category,
      note: note ?? this.note,
    );
  }

  @override
  String toString() => '$name, $category, kupione: $isBought';

  @override
  List<Object?> get props => [id, name, category, isBought, note];
}