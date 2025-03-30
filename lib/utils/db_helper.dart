import 'package:project/db/profile_actions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  Database? _database;

  Future<Database> get db async {
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
        profile.createTable(db);
      },
    );
  }

  static ProfileActions get profile => ProfileActions();
}
