import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const _databaseName = "bibliomate.db";
  static const _databaseVersion = 4;
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) {
      return _database!;
    }

    _database = await openDatabase(
      join(await getDatabasesPath(), _databaseName),
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );

    return _database!;
  }

  static Future<void> _onCreate(Database db, int version) async {
    // Create users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL UNIQUE,
        username TEXT NOT NULL,
        profilePictureUrl TEXT,
        passwordHash TEXT NOT NULL
      )
    ''');

    // Create books table
    await db.execute('''
      CREATE TABLE books (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        imageUrl TEXT NOT NULL,
        pdfContentUrl TEXT NOT NULL,
        publishDate TEXT,
        uploaderId INTEGER NOT NULL,
        FOREIGN KEY (uploaderId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Create lists table
    await db.execute('''
      CREATE TABLE lists (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        listName TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Create saves table
    await db.execute('''
      CREATE TABLE saves (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        listId INTEGER NOT NULL,
        bookId INTEGER NOT NULL,
        FOREIGN KEY (listId) REFERENCES lists (id) ON DELETE CASCADE,
        FOREIGN KEY (bookId) REFERENCES books (id) ON DELETE CASCADE
      )
    ''');
  }

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async { }
}
