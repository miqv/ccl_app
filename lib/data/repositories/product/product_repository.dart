import 'package:ccl_app/data/remote/db/db_client.dart';
import 'package:ccl_app/data/repositories/product/product_mapper.dart';
import 'package:ccl_app/domain/core/failures.dart';
import 'package:ccl_app/domain/model/product.dart';
import 'package:ccl_app/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

/// Implementation of the [ProductRepository] interface.
///
/// This class handles interaction with the local SQLite database
/// through the [DatabaseClient], providing product-related operations.
@Injectable(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({
    required this.dbClient,
    required this.mapper,
  });

  /// The database client responsible for executing SQL operations.
  final DatabaseClient dbClient;

  /// Mapper used to transform raw database results into [Product] objects.
  final ProductMapper mapper;

  /// Retrieves all products with aggregated stock data (inputs and outputs).
  ///
  /// Returns a list of [Product] or a [Failure] if the operation fails.
  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    Either<String, dynamic> result =
    await dbClient.rawQuery(mapper.allProductInfoTableQuery);
    return result.fold(
          (String l) => left(ServerFailure(message: l.toString())),
          (dynamic response) async {
        final List<Map<String, dynamic>> data =
        List<Map<String, dynamic>>.from(response);
        List<Product> products =
        data.map((map) => Product.fromMap(map)).toList();
        return right(products);
      },
    );
  }

  /// Retrieves a single product by its name.
  ///
  /// Returns the matching [Product] or a [Failure] if not found or an error occurs.
  @override
  Future<Either<Failure, Product>> getProduct(String name) async {
    Either<String, dynamic> result =
    await dbClient.get('products', 'name = ?', [name]);
    return result.fold(
          (String l) => left(ServerFailure(message: l.toString())),
          (dynamic response) async {
        final products = await mapper.mapToProducts(response);
        if (products.isEmpty) {
          return left(UnknownFailure(message: ""));
        }
        return right(products.first);
      },
    );
  }

  /// Adds a new product to the database.
  ///
  /// If the table does not exist, it will be created first.
  /// Returns the newly created [Product] or a [Failure] if something goes wrong.
  @override
  Future<Either<Failure, Product>> newProduct(Product product) async {
    Either<String, bool> existsTable = await dbClient.existsTable('products');
    return existsTable.fold(
          (String l) => left(ServerFailure(message: l.toString())),
          (bool exists) async {
        if (!exists) {
          await dbClient.executeQuery(mapper.createTableQuery);
        }

        Either<String, dynamic> result =
        await dbClient.insert('products', product.toMap());
        return result.fold(
              (String l) => left(ServerFailure(message: l.toString())),
              (dynamic response) async {
            // After insertion, fetch and return the saved product
            return getProduct(product.name);
          },
        );
      },
    );
  }

  /// Retrieves a product by its unique ID.
  ///
  /// Returns the [Product] if found, or a [Failure] otherwise.
  @override
  Future<Either<Failure, Product>> getProductId(int productId) async {
    Either<String, dynamic> result =
    await dbClient.get('products', 'id = ?', [productId]);
    return result.fold(
          (String l) => left(ServerFailure(message: l.toString())),
          (dynamic response) async {
        final products = await mapper.mapToProducts(response);
        if (products.isEmpty) {
          return left(UnknownFailure(message: ""));
        }
        return right(products.first);
      },
    );
  }
}
