import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AddressDatabase {
  static Database? _database;
  static const tableName = 'addresses';
  static const columnId = 'id';
  static const columnAddressType = 'addressType';
  static const columnAddressName = 'addressName';
  static const columnFullName = 'fullName';
  static const columnFlatBuilding = 'flatBuilding';
  static const columnLandmark = 'landmark';
  static const columnState = 'state';
  static const columnCity = 'city';
  static const columnPincode = 'pincode';
  static const columnAlternateMobile = 'alternateMobile';

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'addresses.db');

    return await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          '''CREATE TABLE $tableName(
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnAddressType TEXT,
            $columnAddressName TEXT,
            $columnFullName TEXT,
            $columnFlatBuilding TEXT,
            $columnLandmark TEXT,
            $columnState TEXT,
            $columnCity TEXT,
            $columnPincode TEXT,
            $columnAlternateMobile TEXT
          )''',
        );
      },
      version: 1,
    );
  }

  static Future<void> insertAddress(Map<String, dynamic> address) async {
    final db = await database;
    await db.insert(tableName, address);
  }

  static Future<void> updateAddress(
      int id, Map<String, dynamic> address) async {
    final db = await database;
    await db.update(
      tableName,
      address,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteAddress(int id) async {
    final db = await database;
    await db.delete(
      tableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, dynamic>>> getAddresses() async {
    final db = await database;
    return await db.query(tableName);
  }
}
