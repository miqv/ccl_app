part of 'products_cubit.dart';

/// Base class for all product-related states used by the ProductsCubit.
abstract class ProductsState {
  const ProductsState();
}

/// Base class for states that implement equality comparison using Equatable.
/// Helps prevent unnecessary rebuilds in the UI.
abstract class ProductsStateEquatable extends ProductsState
    with EquatableMixin {
  const ProductsStateEquatable();

  @override
  List<Object> get props =>
      <Object>[]; // Default implementation with no properties.
}

/// Initial state when the product screen or cubit is first loaded.
class ProductsInit extends ProductsStateEquatable {}

/// State representing successful retrieval of a list of products.
class ProductsSuccess extends ProductsState {
  final List<Product> results;

  ProductsSuccess(this.results);
}

/// State representing a failure during any product-related operation.
class ProductsFailure extends ProductsState {
  final String errorMessage;

  const ProductsFailure({required this.errorMessage});
}

/// State emitted when data is being loaded (e.g., fetching or searching products).
class ProductsLoading extends ProductsState {}

/// State indicating that no matching products were found during a search.
class ProductsNoResultsFound extends ProductsState {}
