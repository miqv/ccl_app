import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

/// Cliente de base de datos SQLite para la aplicación CCL.
///
/// Esta clase proporciona métodos para inicializar, insertar, consultar,
/// actualizar y eliminar datos de una base de datos local.
///
/// También se encarga de copiar una base de datos preconstruida desde los assets
/// al almacenamiento local del dispositivo en su primer uso.
///
/// Utiliza:
/// - `sqflite` para el manejo de la base de datos.
/// - `dartz` para manejar resultados con `Either`, permitiendo errores controlados.
/// - `injectable` para inyección de dependencias.
@injectable
class DatabaseClient {
  static const _databaseName = 'ccl_app_bd.sqlite';
  static const _databasePath = 'assets/database/ccl_app_bd.sqlite';

  /// Instancia única (singleton) del cliente de base de datos.
  factory DatabaseClient() => instance;
  static final DatabaseClient instance = DatabaseClient._init();
  static Database? _db;

  DatabaseClient._init();

  /// Obtiene o inicializa la base de datos.
  Future<Database> get database async {
    if (_db != null && _db!.isOpen) return _db!;
    _db = await _initDB();
    return _db!;
  }

  /// Inicializa la base de datos desde assets si no existe en almacenamiento local.
  Future<Database> _initDB() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = "${dir.path}/$_databaseName";

    // Si ya existe, ábrela
    if (await File(dbPath).exists()) {
      return await openDatabase(dbPath);
    }

    // Si no existe, copia desde assets
    final data = await rootBundle.load(_databasePath);
    final bytes = data.buffer.asUint8List();
    await File(dbPath).writeAsBytes(bytes);

    return await openDatabase(dbPath);
  }

  /// Inserta un nuevo registro en la tabla especificada.
  ///
  /// Retorna [Right(id)] en caso de éxito o [Left(error)] en caso de error.
  Future<Either<String, int>> insert(
      String table, Map<String, dynamic> data) async {
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

  /// Obtiene todos los registros de la tabla especificada.
  Future<Either<String, List<Map<String, dynamic>>>> getAll(
      String table) async {
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

  /// Obtiene registros filtrando por un campo específico.
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

  /// Actualiza un registro por ID en la tabla especificada.
  Future<Either<String, int>> update(
    String table,
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      if (data.isEmpty) return Left("No data");
      if (table.isEmpty) return Left("No table");
      final db = await instance.database;
      final result =
          await db.update(table, data, where: 'id = ?', whereArgs: [id]);
      await db.close();
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  /// Elimina un registro por ID en la tabla especificada.
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

  /// Ejecuta una consulta SQL directa (como `CREATE`, `DROP`, etc.).
  Future<Either<String, void>> executeQuery(String query) async {
    try {
      if (query.isEmpty) return Left("No query");
      final db = await instance.database;
      final result = await db.execute(query);
      await db.close();
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  /// Verifica si una tabla con el nombre dado existe en la base de datos.
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
}
