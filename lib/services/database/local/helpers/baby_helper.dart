import 'package:sqflite/sqflite.dart';
import 'package:go_parent/services/database/local/models/baby_model.dart';

class BabyHelper {
  final Database db;

  BabyHelper(this.db);

  /// Insert a new baby into the database
  Future<int> insertBaby(BabyModel baby) async {
    return await db.insert(
      'babydb',
      baby.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Retrieve a baby by ID
  Future<BabyModel?> getBabyById(int babyId) async {
    final List<Map<String, dynamic>> result = await db.query(
      'babydb',
      where: 'babyId = ?',
      whereArgs: [babyId],
    );

    if (result.isNotEmpty) {
      return BabyModel.fromMap(result.first);
    }
    return null;
  }

  /// Retrieve all babies linked to a specific user
  Future<List<BabyModel>> getBabiesByUserId(int userId) async {
    final List<Map<String, dynamic>> result = await db.query(
      'babydb',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return result.map((map) => BabyModel.fromMap(map)).toList();
  }

  /// Retrieve all babies (useful for administrative purposes)
  Future<List<BabyModel>> getAllBabies() async {
    final List<Map<String, dynamic>> result = await db.query('babydb');

    return result.map((map) => BabyModel.fromMap(map)).toList();
  }

  /// Update baby details
  Future<int> updateBaby(BabyModel baby) async {
    return await db.update(
      'babydb',
      baby.toMap(),
      where: 'babyId = ?',
      whereArgs: [baby.babyId],
    );
  }

  /// Delete a baby by ID
  Future<int> deleteBaby(int babyId) async {
    return await db.delete(
      'babydb',
      where: 'babyId = ?',
      whereArgs: [babyId],
    );
  }

  /// Count the number of babies linked to a specific user
  Future<int> countBabiesByUserId(int userId) async {
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM babydb WHERE userId = ?',
      [userId],
    );

    return result.first['count'] as int;
  }

  /// Check if a baby exists by name and userId
  Future<bool> babyExists(String babyName, int userId) async {
    final List<Map<String, dynamic>> result = await db.query(
      'babydb',
      where: 'babyName = ? AND userId = ?',
      whereArgs: [babyName, userId],
    );

    return result.isNotEmpty;
  }
}
