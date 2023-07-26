import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class WishlistDatabase {
  static Database? _database;
  static const _tableName = 'wishlist';
  static const columnId = 'id';
  static const columnTitle = 'title';
  static const columnImage = 'image';
  static const columnPrice = 'price';

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, 'wishlist.db');

    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE $_tableName (
          $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
          $columnTitle TEXT,
          $columnImage TEXT,
          $columnPrice REAL
        )
        ''');
      },
    );
  }

  static Future<void> addToWishlist({
    required String title,
    String? productId,
    String? varId,
    required String image,
    required String price,
  }) async {
    final db = await database;
    await db.insert(
      _tableName,
      {
        columnTitle: title,
        columnImage: image,
        columnPrice: price,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  static Future<void> removeFromWishlist(String title) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: '$columnTitle = ?',
      whereArgs: [title],
    );
  }

  static Future<List<Map<String, dynamic>>> getWishlistItems() async {
    final db = await database;
    return db.query(_tableName);
  }
}
