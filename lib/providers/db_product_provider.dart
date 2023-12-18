import 'dart:io';

import 'package:flutter_product_db_local/models/product.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProductProvider {
  static Database? _database;

  static const DBNAMEFILE = 'product_database';
  static const PRODUCTTABLE = 'products';

  static final DBProductProvider db = DBProductProvider._();

  DBProductProvider._();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentDirectory.path, '$DBNAMEFILE.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) {
        return db.execute(
          'CREATE TABLE $PRODUCTTABLE(id INTEGER PRIMARY KEY, name TEXT, price REAL)',
        );
      },
    );
  }

  // Read

  Future<List<Product>> getAll() async {
    final db = await database;

    final response = await db!.query(PRODUCTTABLE);

    // final response = await db!.rawQuery('SELECT * from $PRODUCTTABLE');

    List<Product> list = response.isNotEmpty
        ? response.map((product) => Product.fromJson(product)).toList()
        : [];

    return list;
  }

  Future<Product?> getById(int id) async {
    final db = await database;

    final response = await db!.query(
      PRODUCTTABLE,
      where: 'id = ?',
      whereArgs: [id],
    );

    return response.isNotEmpty ? Product.fromJson(response.first) : null;
  }

  // Create

  Future<int> add(Product product) async {
    final db = await database;

    final response = await db!.insert(PRODUCTTABLE, product.toJson());

    // final response = await db!.rawInsert(
    //     'INSERT Into $PRODUCTTABLE (name, price) VALUES (${product.name}, ${product.price})');

    return response;
  }

  // Update

  Future<int> update(int id, Product product) async {
    final db = await database;

    final response = await db!.update(
      PRODUCTTABLE,
      product.toJson(),
      where: 'id = ?',
      whereArgs: [id],
    );

    return response;
  }

  // Delete

  Future<int> delete(int id) async {
    final db = await database;

    final response = db!.delete(
      PRODUCTTABLE,
      where: 'id = ?',
      whereArgs: [id],
    );

    return response;
  }

  deleteAll() async {
    final db = await database;

    final response = db!.delete(PRODUCTTABLE);

    return response;
  }
}
