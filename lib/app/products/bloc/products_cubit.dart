// Domain layer imports for failure handling, use cases, and product model.
import 'package:ccl_app/domain/core/failures.dart';
import 'package:ccl_app/domain/core/use_case.dart';
import 'package:ccl_app/domain/model/product.dart';
import 'package:ccl_app/domain/usecases/product/add_product_usecase.dart';
import 'package:ccl_app/domain/usecases/product/get_product_search_usecase.dart';
import 'package:ccl_app/domain/usecases/product/get_products_usecase.dart';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Import the states associated with this Cubit.
part 'products_state.dart';

/// A Cubit class responsible for managing the product-related states and actions.
/// It handles loading, searching, and adding products using the provided use cases.
@injectable
class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(
    this._getProductsUseCase,
    this._getProductsSearchUseCase,
    this._addProductUseCase,
  ) : super(ProductsInit());

  final GetProductsUseCase _getProductsUseCase;
  final GetProductsSearchUseCase _getProductsSearchUseCase;
  final AddProductUseCase _addProductUseCase;

  String _query = "";

  /// Starts the cubit by loading all products initially.
  Future<void> start() async {
    _loadProducts();
  }

  /// Internal function to fetch the complete product list from the data source.
  Future<void> _loadProducts() async {
    emit(ProductsLoading()); // Show loading state.
    Either<Failure, List<Product>> result =
        await _getProductsUseCase(NoParams());

    result.fold(
      // Emit failure state with message if fetching fails.
      (l) =>
          emit(const ProductsFailure(errorMessage: 'Error fetching products')),
      (r) {
        try {
          if (r.isEmpty) {
            emit(ProductsNoResultsFound()); // No products found.
          } else {
            if(_query.isNotEmpty){
              search(_query);
            }else{
              emit(ProductsSuccess(r)); // Successfully retrieved products.
            }
          }
        } catch (e) {
          emit(ProductsFailure(errorMessage: 'An error occurred'));
        }
      },
    );
  }

  /// Searches products using the given query string.
  void search(String query) async {
    _query = query;
    emit(ProductsLoading()); // Show loading during search.

    try {
      Either<Failure, List<Product>> result =
          await _getProductsSearchUseCase(_query);

      result.fold(
        // Emit error if search fails.
        (l) => emit(
            const ProductsFailure(errorMessage: 'Error searching products')),
        (r) async {
          try {
            if (r.isEmpty) {
              emit(ProductsNoResultsFound()); // No results found for query.
            } else {
              emit(ProductsSuccess(r)); // Successfully found matching products.
            }
          } catch (e) {
            emit(ProductsFailure(errorMessage: 'An error occurred'));
          }
        },
      );
    } catch (e) {
      emit(ProductsFailure(errorMessage: 'An error occurred'));
    }
  }

  /// Adds a new product to the system and reloads the product list on success.
  void addProduct(Product product) async {
    final Either<Failure, Product> result = await _addProductUseCase(product);

    result.fold(
      // Emit failure state if adding the product fails.
      (failure) => emit(ProductsFailure(errorMessage: failure.message)),
      // On success, reload the product list.
      (product) {
        start();
      },
    );
  }
}
