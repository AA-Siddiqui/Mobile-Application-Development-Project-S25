import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), "db1.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE Profile(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            dob TEXT,
            address TEXT,
            department TEXT,
            rollNo TEXT,
            program TEXT,
            email TEXT UNIQUE
          )
        ''');
      },
    );
  }

  Future<void> insertProfile(Map<String, dynamic> profile) async {
    final db = await database;
    await db.insert('Profile', profile,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> fetchProfile() async {
    final db = await database;
    final result = await db.query('Profile', limit: 1);
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> clearProfile() async {
    final db = await database;
    await db.delete('Profile');
  }
}
