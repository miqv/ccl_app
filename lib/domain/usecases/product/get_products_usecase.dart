import 'package:ccl_app/domain/core/failures.dart';
import 'package:ccl_app/domain/core/use_case.dart';
import 'package:ccl_app/domain/global_state/global_state.dart';
import 'package:ccl_app/domain/model/product.dart';
import 'package:ccl_app/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

/// Abstract use case to fetch all products.
///
/// Expects no parameters ([NoParams]) and returns a list of [Product] instances
/// wrapped in a [Either] type, which may represent a [Failure] or a successful result.
abstract class GetProductsUseCase extends UseCase<List<Product>, NoParams> {}

/// Concrete implementation of [GetProductsUseCase].
///
/// Retrieves all products from the [ProductRepository], updates the global in-memory
/// product list stored in [GlobalState], and returns the updated list.
///
/// ### Behavior:
/// - On success:
///   - Clears the existing list of products in [GlobalState].
///   - Adds the fetched products to the global list.
///   - Returns the updated list.
/// - On failure:
///   - Returns a corresponding [Failure] (e.g. [ServerFailure]).
///
/// ### Dependencies:
/// - [GlobalState]: Holds the cached product list used throughout the app.
/// - [ProductRepository]: Provides access to the data source (e.g. SQLite, REST API).
@Injectable(as: GetProductsUseCase)
class GetProductsUseCaseImpl implements GetProductsUseCase {
  GetProductsUseCaseImpl(this.globalState, this.repository);

  final GlobalState globalState;
  final ProductRepository repository;

  @override
  Future<Either<Failure, List<Product>>> call(NoParams params) async {
    final result = await repository.getProducts();
    return result.fold(
          (l) => left(l),
          (List<Product> products) async {
        // Refresh the in-memory product list
        globalState.products.clear();
        globalState.products.addAll(products);
        return right(globalState.products);
      },
    );
  }
}
