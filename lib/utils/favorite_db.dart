import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FavoriteDb {
  static final FavoriteDb instance = FavoriteDb._init();
  static Database? _database;

  FavoriteDb._init();

  //init db
  Future<Database> _initDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  //get dbnya exist or not
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('restaurant_app.db');
    return _database!;
  }

  //create db if not exist
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites (
        id TEXT PRIMARY KEY,
        name TEXT,
        city TEXT,
        pictureId TEXT,
        rating REAL,
        createdAt INTEGER
     
      )
      ''');
  }

  //insert resto to table favorite
  Future<void> insertFavorite(Map<String, dynamic> data) async {
    final db = await instance.database;
    await db.insert(
      'favorites',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace, //replace jika duplicate
    );
  }

  //hapus resto dari table favor base id
  Future<int> deleteFavorite(String id) async {
    final db = await instance.database;
    return await db.delete('favorites', where: 'id =?', whereArgs: [id]);
  }

  //ambil data smua favor
  Future<List<Map<String, dynamic>>> getAllFavorites() async {
    final db = await instance.database;
    return await db.query('favorites', orderBy: 'createdAt DESC');
  }

  //check apakah resto sudah ada di favorit
  Future<bool> isFavorite(String id) async {
    final db = await instance.database;
    final result = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isEmpty;
  }

  //tutup db saat app dispose
  Future close() async {
    final db = await _database;
    if (db != null) {
      await db.close();
    }
  }
}
