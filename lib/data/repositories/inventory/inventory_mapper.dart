import 'package:ccl_app/domain/model/inventory.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';

/// InventoryMapper is responsible for:
/// - Mapping raw database query results into `Inventory` model objects.
/// - Providing SQL query strings for creating input/output tables and retrieving all inventory data.
@injectable
class InventoryMapper {
  /// Converts a dynamic list of raw inventory data from the database into a list of `Inventory` objects.
  /// It parses the date and formats it for UI display.
  List<Inventory> mapToInventories(dynamic result) {
    return (result as List<dynamic>).map(
          (dynamic inventory) {
        DateTime date = DateFormat("yyyy-MM-dd").parse(inventory['date']);
        String dateFormat = DateFormat.yMMMMd().format(date);
        return Inventory(
          id: inventory['id'],
          productId: inventory['product_id'],
          productName: inventory['product_name'],
          description: inventory['description'],
          date: date,
          dateFormat: dateFormat,
          quantity: inventory['quantity'],
          isInput: inventory['is_input'] == 1,
        );
      },
    ).toList();
  }

  /// SQL statement to create the `input` table in the SQLite database.
  /// This table stores records for product entries (inputs).
  String createTableInputQuery = '''
    CREATE TABLE input (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      product_id INTEGER NOT NULL,
      quantity INTEGER NOT NULL,
      date TEXT NOT NULL,
      description TEXT,
      FOREIGN KEY (product_id) REFERENCES products(id)
    );
  ''';

  /// SQL statement to create the `output` table in the SQLite database.
  /// This table stores records for product removals (outputs).
  String createTableOutputQuery = '''
    CREATE TABLE output (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      product_id INTEGER NOT NULL,
      quantity INTEGER NOT NULL,
      date TEXT NOT NULL,
      description TEXT,
      FOREIGN KEY (product_id) REFERENCES products(id)
    );
  ''';

  /// SQL query to fetch all inventory data (both inputs and outputs).
  /// Combines both tables using `UNION ALL`, includes the product name via a JOIN,
  /// and orders the result by date in descending order.
  String allInventoryInfoQuery = '''
    SELECT 
    i.id,
    i.product_id,
    p.name AS product_name,
    i.quantity,
    i.date,
    i.description,
    1 AS is_input
  FROM input i
  JOIN products p ON i.product_id = p.id
  UNION ALL
  SELECT 
    o.id,
    o.product_id,
    p.name AS product_name,
    o.quantity,
    o.date,
    o.description,
    0 AS is_input
  FROM output o
  JOIN products p ON o.product_id = p.id
  ORDER BY date DESC
  ''';
}
