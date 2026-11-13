import 'package:equatable/equatable.dart';
import 'package:shopping_list/core/failures/data_failure.dart';
import 'package:shopping_list/features/shopping_list/domain/entities/catalog_product.dart';
import 'package:shopping_list/features/shopping_list/domain/entities/catalog_product_list_extensions.dart';

class CatalogState extends Equatable {
  final List<CatalogProduct> products;
  final bool isLoading;
  final DataFailure? failure;

  const CatalogState({
    this.products = const [],
    this.isLoading = true,
    this.failure,
  });

  Map<String, List<CatalogProduct>> get groupedProducts =>
      products.groupedByCategory();

  @override
  List<Object?> get props => [products, isLoading, failure];
}
