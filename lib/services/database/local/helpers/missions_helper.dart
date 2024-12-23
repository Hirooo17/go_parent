import 'package:sqflite/sqflite.dart';
import 'package:go_parent/services/database/local/models/missions_model.dart';

class MissionHelper {
  final Database db;

  MissionHelper(this.db);

  /// Insert a new mission into the database
  Future<int> insertMission(MissionModel mission) async {
    return await db.insert(
      'missions',
      mission.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Retrieve a mission by ID
  Future<MissionModel?> getMissionById(int missionId) async {
    final List<Map<String, dynamic>> result = await db.query(
      'missions',
      where: 'missionId = ?',
      whereArgs: [missionId],
    );

    if (result.isNotEmpty) {
      return MissionModel.fromMap(result.first);
    }
    return null;
  }

  /// Retrieve all missions
  Future<List<MissionModel>> getAllMissions() async {
    final List<Map<String, dynamic>> result = await db.query('missions');

    return result.map((map) => MissionModel.fromMap(map)).toList();
  }

  /// Retrieve missions by category (e.g., 'Learning', 'Playtime')
  Future<List<MissionModel>> getMissionsByCategory(String category) async {
    final List<Map<String, dynamic>> result = await db.query(
      'missions',
      where: 'category = ?',
      whereArgs: [category],
    );

    return result.map((map) => MissionModel.fromMap(map)).toList();
  }

  /// Retrieve missions by level (e.g., age-based curation)
  Future<List<MissionModel>> getMissionsByLevel(String level) async {
    final List<Map<String, dynamic>> result = await db.query(
      'missions',
      where: 'level = ?',
      whereArgs: [level],
    );

    return result.map((map) => MissionModel.fromMap(map)).toList();
  }

  /// Update mission details
  Future<int> updateMission(MissionModel mission) async {
    return await db.update(
      'missions',
      mission.toMap(),
      where: 'missionId = ?',
      whereArgs: [mission.missionId],
    );
  }

  /// Delete a mission by ID
  Future<int> deleteMission(int missionId) async {
    return await db.delete(
      'missions',
      where: 'missionId = ?',
      whereArgs: [missionId],
    );
  }

  /// Count the number of missions by category
  Future<int> countMissionsByCategory(String category) async {
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM missions WHERE category = ?',
      [category],
    );

    return result.first['count'] as int;
  }

  /// Check if a mission exists by title
  Future<bool> missionExists(String title) async {
    final List<Map<String, dynamic>> result = await db.query(
      'missions',
      where: 'title = ?',
      whereArgs: [title],
    );

    return result.isNotEmpty;
  }
}
