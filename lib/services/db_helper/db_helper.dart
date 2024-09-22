import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/users_model.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'user_swipe.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY,
            firstName TEXT,
            lastName TEXT,
            email TEXT,
            image TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE accepted_users (
            id INTEGER PRIMARY KEY,
            firstName TEXT,
            lastName TEXT,
            email TEXT,
            image TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE declined_users (
            id INTEGER PRIMARY KEY,
            firstName TEXT,
            lastName TEXT,
            email TEXT,
            image TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert('users', user.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertAcceptedUser(User user) async {
    final db = await database;
    await db.insert('accepted_users', user.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertDeclinedUser(User user) async {
    final db = await database;
    await db.insert('declined_users', user.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<User>> fetchUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');

    return List.generate(maps.length, (i) {
      return User.fromJson(maps[i]);
    });
  }

  Future<List<User>> fetchAcceptedUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('accepted_users');

    return List.generate(maps.length, (i) {
      return User.fromJson(maps[i]);
    });
  }

  Future<List<User>> fetchDeclinedUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('declined_users');

    return List.generate(maps.length, (i) {
      return User.fromJson(maps[i]);
    });
  }

  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearUsers() async {
    final db = await database;
    await db.delete('users');
  }

  // Clear all data from accepted_users and declined_users tables
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('accepted_users');
    await db.delete('declined_users');
  }
}
