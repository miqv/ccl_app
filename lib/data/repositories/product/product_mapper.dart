import 'package:ccl_app/domain/model/product.dart';
import 'package:injectable/injectable.dart';

/// A utility class responsible for mapping and database-related operations
/// concerning the Product entity.
///
/// This includes converting raw query results into `Product` objects and
/// providing SQL queries for creating and querying the products table.
@injectable
class ProductMapper {
  /// Maps a raw query result (typically from SQLite) into a list of `Product` objects.
  ///
  /// Assumes that the input [result] is a `List<Map<String, dynamic>>`
  /// or similar dynamic structure where each map represents a product row.
  ///
  /// Example:
  /// ```dart
  /// final products = productMapper.mapToProducts(queryResult);
  /// ```
  List<Product> mapToProducts(dynamic result) {
    return (result as List<dynamic>).map(
          (dynamic product) {
        return Product(
          id: product['id'],
          name: product['name'],
          description: product['description'],
        );
      },
    ).toList();
  }

  /// SQL query to create the `products` table if it doesn't already exist.
  ///
  /// The table includes:
  /// - `id`: Primary key, auto-incremented
  /// - `name`: Product name (non-null)
  /// - `description`: Optional product description
  String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS products (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      description TEXT
    );
  ''';

  /// SQL query to retrieve all product data along with calculated input/output stock summary.
  ///
  /// Returns:
  /// - `id`, `name`, `description` from the `products` table
  /// - `total_input`: Sum of all input quantities (from `input` table)
  /// - `total_output`: Sum of all output quantities (from `output` table)
  /// - `stock`: Difference between total input and total output
  ///
  /// Uses `LEFT JOIN` to include products even if they have no input/output records.
  String allProductInfoTableQuery = '''
    SELECT 
    p.id, p.name, p.description,
    IFNULL(SUM(i.quantity), 0) AS total_input,
    IFNULL(SUM(o.quantity), 0) AS total_output,
    (IFNULL(SUM(i.quantity), 0) - IFNULL(SUM(o.quantity), 0)) AS stock
  FROM products p
  LEFT JOIN input i ON p.id = i.product_id
  LEFT JOIN output o ON p.id = o.product_id
  GROUP BY p.id
  ORDER BY p.name
  ''';
}
