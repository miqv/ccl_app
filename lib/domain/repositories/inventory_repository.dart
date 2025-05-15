import 'package:ccl_app/domain/core/failures.dart';
import 'package:ccl_app/domain/model/inventory.dart';
import 'package:dartz/dartz.dart';

/// `InventoryRepository` is the abstract contract for all inventory-related
/// data operations. This includes both reading inventory entries and writing
/// new ones (input/output).
///
/// Implementations of this interface should handle data access from
/// local databases, remote sources, or both.
///
/// Each method returns a `Either<Failure, T>` to encapsulate both success and failure cases.
abstract class InventoryRepository {
  /// Retrieves a list of all inventory entries (both input and output).
  ///
  /// On success, returns a list of `Inventory` objects.
  /// On failure, returns a `Failure` object describing the error.
  Future<Either<Failure, List<Inventory>>> getInventories();

  /// Inserts a new inventory entry into the database.
  ///
  /// Takes an `Inventory` object as input.
  /// On success, returns the same `Inventory` object that was inserted.
  /// On failure, returns a `Failure` describing what went wrong.
  Future<Either<Failure, Inventory>> newInventory(Inventory inventory);
}
