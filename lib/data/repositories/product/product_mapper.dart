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

  /// SQL query to retrieve all products along with stock summary.
  ///
  /// Returns the following columns:
  /// - `id`: Product ID
  /// - `name`: Product name
  /// - `description`: Product description
  /// - `total_input`: Sum of quantities from `input` table (nullable)
  /// - `total_output`: Sum of quantities from `output` table (nullable)
  /// - `stock`: Calculated as (total_input - total_output)
  ///
  /// Uses `LEFT JOIN` to include products with no input/output records
  String allProductInfoTableQuery = '''
    SELECT 
  p.id,
  p.name,
  p.description,
  IFNULL(i.total_input, 0) AS total_input,
  IFNULL(o.total_output, 0) AS total_output,
  (IFNULL(i.total_input, 0) - IFNULL(o.total_output, 0)) AS stock
FROM products p
LEFT JOIN (
  SELECT product_id, SUM(quantity) AS total_input
  FROM input
  GROUP BY product_id
) i ON p.id = i.product_id
LEFT JOIN (
  SELECT product_id, SUM(quantity) AS total_output
  FROM output
  GROUP BY product_id
) o ON p.id = o.product_id
ORDER BY p.name ASC;
  ''';
}
