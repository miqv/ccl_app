import 'package:ccl_app/domain/core/failures.dart';
import 'package:ccl_app/domain/core/use_case.dart';
import 'package:ccl_app/domain/global_state/global_state.dart';
import 'package:ccl_app/domain/model/inventory.dart';
import 'package:ccl_app/domain/repositories/inventory_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

/// Abstract use case for searching inventory entries by product name.
///
/// Takes a [String] query and returns either a [Failure] or a list of [Inventory] entries.
abstract class GetInventorySearchUseCase extends UseCase<List<Inventory>, String> {}

/// Implementation of [GetInventorySearchUseCase] that performs an in-memory search
/// on the inventory list stored in [GlobalState].
///
/// This use case does not perform any database query. Instead, it filters the
/// already loaded list of inventories in memory, which improves performance for search operations.
@Injectable(as: GetInventorySearchUseCase)
class GetInventorySearchUseCaseImpl implements GetInventorySearchUseCase {
  GetInventorySearchUseCaseImpl(this.globalState, this.repository);

  final GlobalState globalState;
  final InventoryRepository repository;

  /// Filters the in-memory inventory list based on the search [query].
  ///
  /// If the [query] is empty, the entire inventory list is returned.
  /// Otherwise, it performs a case-insensitive match on [Inventory.productName].
  ///
  /// Always returns a [Right] with the filtered list (search errors are not expected).
  @override
  Future<Either<Failure, List<Inventory>>> call(String query) async {
    if (query.isEmpty) {
      return right(globalState.inventories);
    }

    final List<Inventory> result = globalState.inventories
        .where((Inventory inventory) =>
        inventory.description.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return right(result);
  }
}
