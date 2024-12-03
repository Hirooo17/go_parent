import 'package:sqflite/sqflite.dart';
import 'package:go_parent/Database/Models/user_model.dart';

class UserHelper {
  final Database db;

  UserHelper(this.db);

  /// Insert a new user into the database
  Future<int> insertUser(UserModel user) async {
    return await db.insert(
      'userdb',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Retrieve a user by ID
  Future<UserModel?> getUserById(int userId) async {
    final List<Map<String, dynamic>> result = await db.query(
      'userdb',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }
    return null;
  }

  /// Retrieve all users
  Future<List<UserModel>> getAllUsers() async {
    final List<Map<String, dynamic>> result = await db.query('userdb');

    return result.map((map) => UserModel.fromMap(map)).toList();
  }

  /// Update a user in the database
  Future<int> updateUser(UserModel user) async {
    return await db.update(
      'userdb',
      user.toMap(),
      where: 'userId = ?',
      whereArgs: [user.userId],
    );
  }

  /// Delete a user by ID
  Future<int> deleteUser(int userId) async {
    return await db.delete(
      'userdb',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  /// Check if a user exists by email (for login or sign-up validation)
  Future<bool> userExists(String email) async {
    final List<Map<String, dynamic>> result = await db.query(
      'userdb',
      where: 'email = ?',
      whereArgs: [email],
    );

    return result.isNotEmpty;
  }

  /// Get total score for a user
  Future<int> getTotalScore(int userId) async {
    final List<Map<String, dynamic>> result = await db.query(
      'userdb',
      columns: ['totalScore'],
      where: 'userId = ?',
      whereArgs: [userId],
    );

    if (result.isNotEmpty) {
      return result.first['totalScore'] as int;
    }
    return 0;
  }

  /// Increment the user's total score (e.g., when completing missions)
  Future<int> incrementUserScore(int userId, int points) async {
    final currentScore = await getTotalScore(userId);
    final newScore = currentScore + points;

    return await db.update(
      'userdb',
      {'totalScore': newScore},
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }
}
