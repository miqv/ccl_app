import 'package:ccl_app/domain/core/failures.dart';
import 'package:ccl_app/domain/core/use_case.dart';
import 'package:ccl_app/domain/model/inventory.dart';
import 'package:ccl_app/domain/model/product.dart';
import 'package:ccl_app/domain/usecases/inventory/add_inventory_usecase.dart';
import 'package:ccl_app/domain/usecases/inventory/get_inventory_search_usecase.dart';
import 'package:ccl_app/domain/usecases/inventory/get_inventories_usecase.dart';
import 'package:ccl_app/domain/usecases/product/get_products_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'inventory_state.dart';

/// Manages the state and logic for inventory-related operations such as:
/// - Fetching inventories
/// - Searching inventories
/// - Adding inventory entries (input/output)
/// - Fetching product list
///
/// Uses [InventoryState] to emit UI states based on the operation result.
/// Depends on use cases to interact with the domain layer.
@injectable
class InventoryCubit extends Cubit<InventoryState> {
  InventoryCubit(
      this._getInventoriesUseCase,
      this._getInventorySearchUseCase,
      this._getProductsUseCase,
      this._addInventoryUseCase,
      ) : super(InventoryInit());

  final GetInventoriesUseCase _getInventoriesUseCase;
  final GetInventorySearchUseCase _getInventorySearchUseCase;
  final GetProductsUseCase _getProductsUseCase;
  final AddInventoryUseCase _addInventoryUseCase;

  /// Callback used after a successful inventory creation.
  late VoidCallback? onBack;

  String _query = "";

  /// Initializes the inventory screen by loading all inventory entries.
  Future<void> start() async {
    _loadInventory();
  }

  /// Internal function to load all inventory records.
  Future<void> _loadInventory() async {
    emit(InventoryLoading());
    Either<Failure, List<Inventory>> result =
    await _getInventoriesUseCase(NoParams());

    result.fold(
      // Emits failure state on error.
          (l) =>
          emit(const InventoryFailure(errorMessage: 'Error fetching inventory')),
          (r) {
        try {
          if (r.isEmpty) {
            emit(InventoryNoResultsFound());
          } else {
            if(_query.isNotEmpty){
              search(_query);
            }else{
              emit(InventorySuccess(r));
            }
          }
        } catch (e) {
          emit(InventoryFailure(errorMessage: 'An error occurred'));
        }
      },
    );
  }

  /// Searches inventory entries by [query] string.
  void search(String query) async {
    _query = query;
    emit(InventoryLoading());

    try {
      Either<Failure, List<Inventory>> result =
      await _getInventorySearchUseCase(_query);

      result.fold(
            (l) =>
            emit(const InventoryFailure(errorMessage: 'Error searching inventory')),
            (r) async {
          try {
            if (r.isEmpty) {
              emit(InventoryNoResultsFound());
            } else {
              emit(InventorySuccess(r));
            }
          } catch (e) {
            emit(InventoryFailure(errorMessage: 'An error occurred'));
          }
        },
      );
    } catch (e) {
      emit(InventoryFailure(errorMessage: 'An error occurred'));
    }
  }

  /// Fetches all available products for input/output selection.
  ///
  /// The [onBack] callback will be stored to be executed after successful submission.
  Future<void> getAllProducts({required VoidCallback? onBack}) async {
    this.onBack = onBack;
    Either<Failure, List<Product>> result =
    await _getProductsUseCase(NoParams());

    result.fold(
          (l) =>
          emit(const InventoryFailure(errorMessage: 'Error fetching products')),
          (r) {
        try {
          if (r.isEmpty) {
            emit(InventoryNoResultsFound());
          } else {
            emit(InventoryProductsSuccess(r));
          }
        } catch (e) {
          emit(InventoryFailure(errorMessage: 'An error occurred'));
        }
      },
    );
  }

  /// Adds a new inventory entry to the database.
  ///
  /// The [inventory] object must include all required fields.
  /// Emits success or failure states based on the result.
  void addInventory(Inventory inventory) async {
    final Either<Failure, Inventory> result =
    await _addInventoryUseCase(inventory);

    result.fold(
          (failure) => emit(InventoryCreatedFailure(errorMessage: failure.message)),
          (inventory) {
        if (onBack != null) {
          onBack!(); // Executes post-submit callback (e.g., pop view)
        }
        emit(InventoryCreatedSuccess(isInput: inventory.isInput));
      },
    );
  }
}
