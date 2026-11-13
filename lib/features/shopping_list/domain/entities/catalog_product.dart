import 'package:equatable/equatable.dart';

class CatalogProduct extends Equatable {
  final String id;
  final String name;
  final String category;
  final int useCount;
  final bool isPinned;

  const CatalogProduct({
    required this.id,
    required this.name,
    required this.category,
    this.useCount = 0,
    this.isPinned = false,
  });

  CatalogProduct copyWith({String? name, String? category, bool? isPinned}) {
    return CatalogProduct(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      useCount: useCount,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  @override
  List<Object?> get props => [id, name, category, useCount, isPinned];
}
