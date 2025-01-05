import 'package:sqflite/sqflite.dart';
import 'package:go_parent/services/database/local/models/user_model.dart';

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


  Future<UserModel?> getUserByEmail(String email) async {
    final List<Map<String, dynamic>> result = await db.query(
      'userdb',
      where: 'email = ?',
      whereArgs: [email],
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

  /// Update a user's password
  Future<bool> updateUserPassword(String email, String newPassword) async {
    final int count = await db.update(
      'userdb',
      {'password': newPassword},
      where: 'email = ?',
      whereArgs: [email],
    );

    return count > 0; // Returns true if the password was updated successfully
  }

  /// Delete a user by ID
  Future<int> deleteUser(int userId) async {
    return await db.delete(
      'userdb',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  Future<bool> userExists(String email) async {
    final List<Map<String, dynamic>> result = await db.query(
      'userdb',
      where: 'email = ?',
      whereArgs: [email],
    );

    return result.isNotEmpty;
  }


  Future<bool> updateUserPassword(String email, String hashedPassword) async {
    try {
      print('Attempting to update password for email: $email');

      final rowsUpdated = await db.update(
        'userdb',
        {'password': hashedPassword},
        where: 'email = ?',
        whereArgs: [email],
      );

      if (rowsUpdated > 0) {
        print('Password updated successfully for email: $email');
        return true;
      } else {
        print('No user found with the given email: $email');
        return false; // Email doesn't exist in the database
      }
    } catch (e) {
      print('Error while updating password: $e');
      return false;
    }
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
