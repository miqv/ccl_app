import 'package:ccl_app/domain/core/failures.dart';
import 'package:ccl_app/domain/model/product.dart';
import 'package:dartz/dartz.dart';

/// Abstract contract that defines operations for managing [Product] entities.
///
/// This interface is designed for dependency inversion and allows for different
/// implementations (e.g., local DB, remote API). Each method returns a `Future`
/// of an `Either<Failure, Result>` to support functional error handling via the
/// `dartz` package.
///
/// ### Responsibilities:
/// - Fetching product list or individual products by name or ID.
/// - Persisting new products to the data source.
///
/// ### Error Handling:
/// All methods return `Either<Failure, T>` where:
/// - `Left(Failure)` indicates an error (e.g., network, server, validation).
/// - `Right(T)` contains the expected successful result.
///
/// ### Example Usage:
/// ```dart
/// final result = await repository.getProduct('Cement');
/// result.fold(
///   (failure) => handleError(failure),
///   (product) => useProduct(product),
/// );
/// ```
abstract class ProductRepository {
  /// Fetches a list of all available products.
  ///
  /// Returns:
  /// - `Right(List<Product>)` on success.
  /// - `Left(Failure)` on failure (e.g., DB error).
  Future<Either<Failure, List<Product>>> getProducts();

  /// Retrieves a product by its [name].
  ///
  /// Returns:
  /// - `Right(Product)` if found.
  /// - `Left(Failure)` if not found or error occurs.
  Future<Either<Failure, Product>> getProduct(String name);

  /// Retrieves a product using its unique [productId].
  ///
  /// Returns:
  /// - `Right(Product)` on success.
  /// - `Left(Failure)` if not found or error occurs.
  Future<Either<Failure, Product>> getProductId(int productId);

  /// Inserts a new [Product] into the data source.
  ///
  /// Returns:
  /// - `Right(Product)` with the newly created entity.
  /// - `Left(Failure)` if creation fails (e.g., DB error).
  Future<Either<Failure, Product>> newProduct(Product product);
}
