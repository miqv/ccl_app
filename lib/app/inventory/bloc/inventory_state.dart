part of 'inventory_cubit.dart';

/// Base abstract class for all inventory-related states used by the [InventoryCubit].
///
/// This is useful for defining a sealed state model for inventory operations such as
/// loading, success, failure, search results, and creation status.
abstract class InventoryState {
  const InventoryState();
}

/// A base class for inventory states that implement [EquatableMixin] for value comparison.
///
/// This is helpful to avoid unnecessary widget rebuilds when states with the same properties
/// are emitted multiple times.
abstract class InventoryStateEquatable extends InventoryState
    with EquatableMixin {
  const InventoryStateEquatable();

  @override
  List<Object> get props => <Object>[]; // Override for comparison logic.
}

/// State representing the initial state of the inventory screen or cubit.
///
/// Typically emitted before any operation is performed.
class InventoryInit extends InventoryStateEquatable {}

/// State representing the successful retrieval of a list of [Inventory] entries.
class InventorySuccess extends InventoryState {
  final List<Inventory> results;

  InventorySuccess(this.results);
}

/// State representing the successful retrieval of a list of [Product] entries.
///
/// This is usually emitted when loading product data for input/output forms.
class InventoryProductsSuccess extends InventoryState {
  final List<Product> results;

  InventoryProductsSuccess(this.results);
}

/// State indicating that an inventory creation operation has failed.
///
/// Contains an [errorMessage] that describes the failure reason.
class InventoryCreatedFailure extends InventoryState {
  final String errorMessage;

  const InventoryCreatedFailure({required this.errorMessage});
}

/// State indicating that an inventory entry was successfully created.
class InventoryCreatedSuccess extends InventoryState {
  final bool isInput;

  const InventoryCreatedSuccess({required this.isInput});
}

/// State representing a generic failure in any inventory-related operation.
///
/// Includes an [errorMessage] for user feedback or logging.
class InventoryFailure extends InventoryState {
  final String errorMessage;

  const InventoryFailure({required this.errorMessage});
}

/// State emitted when an inventory operation is in progress (e.g. loading or searching).
class InventoryLoading extends InventoryState {}

/// State emitted when no inventory entries or search results are found.
///
/// Useful for displaying "no results" messages in the UI.
class InventoryNoResultsFound extends InventoryState {}
