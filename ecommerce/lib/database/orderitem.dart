import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class OrderItemsDatabase {
  static Database? _database;
  static const _tableName = 'orderitems';
  static const _columnId = 'id';
  static const _columnTitle = 'title';
  static const _columnImage = 'image';
  static const _columnPrice = 'price';
  static const _columnQuantity = 'quantity';

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, 'orderitems.db');

    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE $_tableName (
          $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
          $_columnTitle TEXT,
          $_columnImage TEXT,
          $_columnPrice REAL,
          $_columnQuantity INTEGER
        )
        ''');
      },
    );
  }

  static Future<bool> isProductInOrder(String title) async {
    final db = await database;
    final items = await db.query(
      _tableName,
      where: '$_columnTitle = ?',
      whereArgs: [title],
    );
    return items.isNotEmpty;
  }

  static Future<void> addToOrder({
    required String title,
    required String image,
    required String price,
    int quantity = 1,
  }) async {
    final db = await database;
    final existingItems = await db.query(
      _tableName,
      where: '$_columnTitle = ?',
      whereArgs: [title],
    );

    if (existingItems.isNotEmpty) {
      final currentQuantity = existingItems[0][_columnQuantity] as int;
      final newQuantity = currentQuantity + quantity;

      await db.update(
        _tableName,
        {
          _columnQuantity: newQuantity,
        },
        where: '$_columnTitle = ?',
        whereArgs: [title],
      );
    } else {
      await db.insert(
        _tableName,
        {
          _columnTitle: title,
          _columnImage: image,
          _columnPrice: price,
          _columnQuantity: quantity,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  static Future<void> removeFromOrder(String title) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: '$_columnTitle = ?',
      whereArgs: [title],
    );
  }

  static Future<void> updateOrderItemQuantity(String title, int quantity) async {
    final db = await database;
    await db.update(
      _tableName,
      {_columnQuantity: quantity},
      where: '$_columnTitle = ?',
      whereArgs: [title],
    );
  }

  static Future<List<Map<String, dynamic>>> getOrderItems() async {
    final db = await database;
    return db.query(_tableName);
  }
}
