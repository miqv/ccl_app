import 'package:ccl_app/domain/core/failures.dart';
import 'package:ccl_app/domain/core/use_case.dart';
import 'package:ccl_app/domain/global_state/global_state.dart';
import 'package:ccl_app/domain/model/inventory.dart';
import 'package:ccl_app/domain/repositories/inventory_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

/// Abstract use case contract for retrieving the list of inventories.
///
/// Takes [NoParams] and returns either a [Failure] or a [List] of [Inventory] items.
abstract class GetInventoriesUseCase extends UseCase<List<Inventory>, NoParams> {}

/// Implementation of [GetInventoriesUseCase] that fetches inventory data from the repository
/// and updates the application's [GlobalState].
///
/// This use case is used to retrieve all inventory entries from both input and output tables.
/// The retrieved list is stored in [globalState.inventories] for shared state access.
@Injectable(as: GetInventoriesUseCase)
class GetInventoriesUseCaseImpl implements GetInventoriesUseCase {
  GetInventoriesUseCaseImpl(this.globalState, this.repository);

  final GlobalState globalState;
  final InventoryRepository repository;

  /// Executes the use case to retrieve all inventories from the [InventoryRepository].
  ///
  /// On success, the resulting list is also stored in [globalState.inventories].
  /// Returns a [Right] with the list of inventories, or a [Left] with a [Failure] on error.
  @override
  Future<Either<Failure, List<Inventory>>> call(NoParams params) async {
    final result = await repository.getInventories();
    return result.fold(
          (l) => left(l),
          (List<Inventory> inventories) async {
        globalState.inventories.clear();
        globalState.inventories.addAll(inventories);
        return right(globalState.inventories);
      },
    );
  }
}
