import 'package:ccl_app/domain/core/failures.dart';
import 'package:ccl_app/domain/core/use_case.dart';
import 'package:ccl_app/domain/global_state/global_state.dart';
import 'package:ccl_app/domain/model/inventory.dart';
import 'package:ccl_app/domain/repositories/inventory_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

/// Abstract use case contract for adding a new inventory entry.
///
/// Takes an [Inventory] object and returns either a [Failure]
/// or the successfully added [Inventory].
abstract class AddInventoryUseCase extends UseCase<Inventory, Inventory> {}

/// Implementation of [AddInventoryUseCase] that delegates the insertion
/// of inventory data to an [InventoryRepository].
///
/// This use case encapsulates the logic for persisting new inventory records,
/// using dependency-injected [InventoryRepository] and [GlobalState].
@Injectable(as: AddInventoryUseCase)
class AddInventoryUseCaseImpl implements AddInventoryUseCase {
  AddInventoryUseCaseImpl(this.globalState, this.repository);

  final GlobalState globalState;
  final InventoryRepository repository;

  /// Executes the use case by calling the repository to insert the given inventory.
  ///
  /// Returns a [Right] containing the inserted [Inventory] on success,
  /// or a [Left] with [Failure] on error.
  @override
  Future<Either<Failure, Inventory>> call(Inventory inventory) async {
    final result = await repository.newInventory(inventory);

    return result.fold(
          (l) => left(l),
          (Inventory inventory) async {
        return right(inventory);
      },
    );
  }
}
