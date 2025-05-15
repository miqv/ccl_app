import 'package:ccl_app/domain/core/failures.dart';
import 'package:ccl_app/domain/core/use_case.dart';
import 'package:ccl_app/domain/global_state/global_state.dart';
import 'package:ccl_app/domain/model/product.dart';
import 'package:ccl_app/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

/// Abstract use case for searching products by name.
///
/// Takes a search query (as [String]) and returns a list of [Product]
/// instances whose names match the query.
abstract class GetProductsSearchUseCase
    extends UseCase<List<Product>, String> {}

/// Concrete implementation of [GetProductsSearchUseCase].
///
/// This use case provides in-memory filtering of the products stored in
/// the [GlobalState]. It does not query a database or repository.
///
/// ### Behavior:
/// - If the search [query] is empty, all products from [GlobalState] are returned.
/// - Otherwise, filters the products where the `name` contains the [query]
///   (case-insensitive).
///
/// ### Dependencies:
/// - [GlobalState] which holds the list of all cached products.
/// - [ProductRepository] is injected but unused in this implementation;
///   it may be used for future enhancements like server-side search.
@Injectable(as: GetProductsSearchUseCase)
class GetProductsSearchUseCaseImpl implements GetProductsSearchUseCase {
  GetProductsSearchUseCaseImpl(this.globalState, this.repository);

  final GlobalState globalState;
  final ProductRepository repository;

  @override
  Future<Either<Failure, List<Product>>> call(String query) async {
    if (query.isEmpty) {
      // Return all cached products if query is empty
      return right(globalState.products);
    }

    // Case-insensitive search by product name
    final List<Product> result = globalState.products
        .where((Product product) =>
        product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return right(result);
  }
}
