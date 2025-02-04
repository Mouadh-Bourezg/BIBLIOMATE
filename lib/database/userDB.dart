import 'package:sqflite/sqflite.dart';
import './dbhelper.dart';
import '../models/user.dart';

class UserDB {
  // Fetch all users
  static Future<List<User>> getAllUsers() async {
    final database = await DBHelper.getDatabase();
    final List<Map<String, dynamic>> usersMap = await database.query('users');
    return usersMap.map((userMap) => User.fromMap(userMap)).toList();
  }

  // Fetch a user by ID
  static Future<User?> getUserById(int id) async {
    final database = await DBHelper.getDatabase();
    final result = await database.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? User.fromMap(result.first) : null;
  }

  // Insert a new user
  static Future<int> insertUser(User user) async {
    final database = await DBHelper.getDatabase();
    return await database.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Update user details
  static Future<int> updateUser(User user) async {
    final database = await DBHelper.getDatabase();
    return await database.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Delete a user by ID
  static Future<int> deleteUser(int id) async {
    final database = await DBHelper.getDatabase();
    return await database.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
