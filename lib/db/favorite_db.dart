import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FavoriteDb {
  static final FavoriteDb instance = FavoriteDb._init();
  static Database? _database;

  FavoriteDb._init();

  Future<Database> _initDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('restaurant_app.db');
    return _database!;
  }

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

  Future<void> insertFavorite(Map<String, dynamic> data) async {
    final db = await instance.database;
    await db.insert(
      'favorites',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteFavorite(String id) async {
    final db = await instance.database;
    return await db.delete('favorites', where: 'id =?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getAllFavorites() async {
    final db = await instance.database;
    return await db.query('favorites', orderBy: 'createdAt DESC');
  }

  Future<bool> isFavorite(String id) async {
    final db = await instance.database;
    final result = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future close() async {
    final db = _database;
    if (db != null) {
      await db.close();
    }
  }
}
