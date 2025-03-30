import 'package:project/utils/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class ProfileActions {
  static final ProfileActions _instance = ProfileActions._internal();
  factory ProfileActions() => _instance;
  ProfileActions._internal();

  final database = DBHelper().db;
  Future<void> createTable(Database db) async {
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
