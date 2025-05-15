import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

/// SQLite database client for the CCL application.
///
/// This class provides helper methods to initialize and operate
/// on a local SQLite database, including inserting, querying, updating,
/// and deleting records.
///
/// It also handles the one-time copying of a pre-built database
/// from the app assets to the device's local storage.
///
/// Uses:
/// - `sqflite` for database access.
/// - `dartz` for safe error handling via `Either`.
/// - `injectable` for dependency injection.
@injectable
class DatabaseClient {
  static const _databaseName = 'ccl_app_bd.sqlite';
  static const _databasePath = 'assets/database/ccl_app_bd.sqlite';

  /// Singleton instance of the database client.
  factory DatabaseClient() => instance;
  static final DatabaseClient instance = DatabaseClient._init();
  static Database? _db;

  DatabaseClient._init();

  /// Returns the opened database instance.
  /// If it doesn't exist, it initializes it from the asset file.
  Future<Database> get database async {
    if (_db != null && _db!.isOpen) return _db!;
    _db = await _initDB();
    return _db!;
  }

  /// Initializes the database.
  /// If the database file does not exist in local storage,
  /// it is copied from the assets.
  Future<Database> _initDB() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = "${dir.path}/$_databaseName";

    if (await File(dbPath).exists()) {
      return await openDatabase(dbPath);
    }

    final data = await rootBundle.load(_databasePath);
    final bytes = data.buffer.asUint8List();
    await File(dbPath).writeAsBytes(bytes);

    return await openDatabase(dbPath);
  }

  /// Inserts a new row into the specified [table].
  ///
  /// Returns [Right(id)] with the inserted record's ID on success,
  /// or [Left(errorMessage)] on failure.
  Future<Either<String, int>> insert(String table, Map<String, dynamic> data) async {
    try {
      if (data.isEmpty) return Left("No data");
      if (table.isEmpty) return Left("No table");
      final db = await instance.database;
      final result = await db.insert(table, data);
      await db.close();
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  /// Retrieves all rows from the specified [table].
  Future<Either<String, List<Map<String, dynamic>>>> getAll(String table) async {
    try {
      if (table.isEmpty) return Left("No table");
      final db = await instance.database;
      final result = await db.query(table);
      await db.close();
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  /// Retrieves rows from [table] where [field] matches [arg].
  Future<Either<String, List<Map<String, dynamic>>>> get(
      String table,
      String field,
      List<Object?> arg,
      ) async {
    try {
      if (table.isEmpty) return Left("No table");
      if (field.isEmpty) return Left("No field");
      if (arg.isEmpty) return Left("No arg");
      final db = await instance.database;
      final result = await db.query(table, where: field, whereArgs: arg);
      await db.close();
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  /// Updates a row by [id] in the specified [table] with new [data].
  Future<Either<String, int>> update(
      String table,
      int id,
      Map<String, dynamic> data,
      ) async {
    try {
      if (data.isEmpty) return Left("No data");
      if (table.isEmpty) return Left("No table");
      final db = await instance.database;
      final result = await db.update(table, data, where: 'id = ?', whereArgs: [id]);
      await db.close();
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  /// Deletes a row by [id] from the specified [table].
  Future<Either<String, int>> delete(String table, int id) async {
    try {
      if (table.isEmpty) return Left("No table");
      final db = await instance.database;
      final result = await db.delete(table, where: 'id = ?', whereArgs: [id]);
      await db.close();
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  /// Executes a raw SQL query (e.g. `CREATE`, `DROP`, etc.).
  Future<Either<String, void>> executeQuery(String query) async {
    try {
      if (query.isEmpty) return Left("No query");
      final db = await instance.database;
      await db.execute(query);
      await db.close();
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  /// Checks if a table named [tableName] exists in the database.
  Future<Either<String, bool>> existsTable(String tableName) async {
    try {
      final db = await instance.database;
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name = ?;",
        [tableName],
      );
      await db.close();
      return Right(tables.isNotEmpty);
    } catch (e) {
      return Left(e.toString());
    }
  }

  /// Executes a raw SQL select query and returns the result.
  Future<Either<String, dynamic>> rawQuery(String query) async {
    try {
      final db = await instance.database;
      final List<Map<String, dynamic>> results = await db.rawQuery(query);
      await db.close();
      return Right(results);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
