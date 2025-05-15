import 'package:ccl_app/data/remote/db/db_client.dart';
import 'package:ccl_app/data/repositories/inventory/inventory_mapper.dart';
import 'package:ccl_app/domain/core/failures.dart';
import 'package:ccl_app/domain/model/inventory.dart';
import 'package:ccl_app/domain/repositories/inventory_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

/// InventoryRepositoryImpl provides the implementation for inventory-related
/// database operations such as fetching all inventory records and creating new ones.
/// It uses a local SQLite database through DatabaseClient.
@Injectable(as: InventoryRepository)
class InventoryRepositoryImpl implements InventoryRepository {
  InventoryRepositoryImpl({
    required this.dbClient,
    required this.mapper,
  });

  /// Client for executing raw SQL queries.
  final DatabaseClient dbClient;

  /// Mapper to provide SQL query strings.
  final InventoryMapper mapper;

  /// Retrieves all inventory records (inputs and outputs).
  /// Returns either a failure or a list of inventory objects.
  @override
  Future<Either<Failure, List<Inventory>>> getInventories() async {
    Either<String, dynamic> result =
    await dbClient.rawQuery(mapper.allInventoryInfoQuery);

    return result.fold(
      // If there's an error executing the query, return a failure.
          (String l) => left(ServerFailure(message: l.toString())),

      // If successful, map each row into an Inventory model.
          (dynamic response) async {
        final List<Map<String, dynamic>> data =
        List<Map<String, dynamic>>.from(response);
        List<Inventory> inventories =
        data.map((map) => Inventory.fromMap(map)).toList();
        return right(inventories);
      },
    );
  }

  /// Inserts a new inventory record into either the 'input' or 'output' table
  /// depending on whether it's an input or output movement.
  /// Returns either a failure or the created inventory object.
  @override
  Future<Either<Failure, Inventory>> newInventory(Inventory inventory) async {
    // Determine the table name based on movement type.
    String nameTable = inventory.isInput ? 'input' : 'output';

    // SQL to create the required table if it doesn't exist.
    String queryCreateTable = inventory.isInput
        ? mapper.createTableInputQuery
        : mapper.createTableOutputQuery;

    // Check if the target table exists.
    Either<String, bool> existsTable = await dbClient.existsTable(nameTable);

    return existsTable.fold(
      // If table existence check fails, return a failure.
          (String l) => left(ServerFailure(message: l.toString())),

      // If successful, and the table doesn't exist, create it.
          (bool exists) async {
        if (!exists) {
          await dbClient.executeQuery(queryCreateTable);
        }

        // Insert the new inventory record.
        Either<String, dynamic> result =
        await dbClient.insert(nameTable, inventory.toMap());

        return result.fold(
          // Return a failure if insert fails.
              (String l) => left(ServerFailure(message: l.toString())),

          // Return the inventory object on success.
              (dynamic response) async {
            return right(inventory);
          },
        );
      },
    );
  }
}
