import 'package:ccl_app/core/translations/localization_constants.dart';
import 'package:ccl_app/domain/core/failures.dart';
import 'package:ccl_app/domain/core/use_case.dart';
import 'package:ccl_app/domain/global_state/global_state.dart';
import 'package:ccl_app/domain/model/product.dart';
import 'package:ccl_app/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';

/// Abstract use case definition for adding a new product.
///
/// This class defines the contract for creating a new [Product]
/// and returning either a [Failure] or the newly created [Product].
abstract class AddProductUseCase extends UseCase<Product, Product> {}

/// Concrete implementation of [AddProductUseCase].
///
/// This use case handles business logic for:
/// - Validating product data (e.g., name and description must not be empty).
/// - Saving the product through the [ProductRepository].
/// - Updating the in-memory [GlobalState] with the new product.
///
/// ### Dependencies:
/// - [GlobalState] to update local memory state.
/// - [ProductRepository] to interact with persistence layer.
///
/// ### Validation:
/// - Fails with [ValidationFailure] if name or description is empty.
/// - Returns [Right(Product)] if addition is successful.
/// - Returns [Left(Failure)] on error (e.g., DB or repository failure).
@Injectable(as: AddProductUseCase)
class AddProductUseCaseImpl implements AddProductUseCase {
  AddProductUseCaseImpl(this.globalState, this.repository);

  final GlobalState globalState;
  final ProductRepository repository;

  @override
  Future<Either<Failure, Product>> call(Product product) async {
    // Validation: required fields
    if (product.name.trim().isEmpty || product.description.trim().isEmpty) {
      return left(
        ValidationFailure(message: LocaleKeys.register.failedMessage.tr()),
      );
    }

    // Save the product via repository
    final result = await repository.newProduct(product);

    // Update state and return result
    return result.fold(
          (l) => left(l),
          (Product product) async {
        globalState.products.add(product);
        return right(product);
      },
    );
  }
}
