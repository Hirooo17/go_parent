import 'package:sqflite/sqflite.dart';
import 'package:go_parent/services/database/local/models/missions_model.dart';

class MissionHelper {
  final Database db;

  MissionHelper(this.db);

  Future<int> insertMission(MissionModel mission) async {
    return await db.insert(
      'missionsdb',
      mission.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  /// Retrieve a mission by ID
  Future<MissionModel?> getMissionById(int missionId) async {
    final List<Map<String, dynamic>> result = await db.query(
      'missionsdb',
      where: 'missionId = ?',
      whereArgs: [missionId],
    );

    if (result.isNotEmpty) {
      return MissionModel.fromMap(result.first);
    }
    return null;
  }


  /// Retrieve missions by category (e.g., 'Learning', 'Playtime')
  Future<List<MissionModel>> getMissionsByCategory(String category) async {
    final List<Map<String, dynamic>> result = await db.query(
      'missionsdb',
      where: 'category = ?',
      whereArgs: [category],
    );

    return result.map((map) => MissionModel.fromMap(map)).toList();
  }


  Future<List<MissionModel>> getAllMissions() async {
    print("Starting getAllMissions query...");

    final List<Map<String, dynamic>> result = await db.query('missionsdb');
    print("Raw query result: $result");  // This will show us the raw data

    final missions = result.map((map) => MissionModel.fromMap(map)).toList();
    print("Converted to MissionModels: ${missions.length} items");

    // Print details of first few missions if any exist
    if (missions.isNotEmpty) {
      print("First mission details: ${missions[0].toMap()}");
    }

    return missions;
  }

  // Retrieve missions based on the baby's age in months
  Future<List<MissionModel>> getMissionsByBabyMonthAge(int babyAgeInMonths) async {
    print("[getMissionsByBabyAge] Baby's age: $babyAgeInMonths months");

    // Query the database for missions within the age range
    final List<Map<String, dynamic>> result = await db.query(
    'missionsdb',
    where: 'minAge <= ? AND maxAge >= ?',
    whereArgs: [babyAgeInMonths, babyAgeInMonths],
    );

    print("[getMissionsByBabyAge] Query result: $result");

    // Map the query result to MissionModel objects
    final missions = result.map((map) => MissionModel.fromMap(map)).toList();
    print("[getMissionsByBabyAge] Found ${missions.length} missions for baby age: $babyAgeInMonths months");

    return missions;
  }


  /// Retrieve missions by completion status
  Future<List<MissionModel>> getMissionsByCompletion(bool isCompleted) async {
    final List<Map<String, dynamic>> result = await db.query(
      'missionsdb',
      where: 'isCompleted = ?',
      whereArgs: [isCompleted ? 1 : 0],
    );

    return result.map((map) => MissionModel.fromMap(map)).toList();
  }


  /// Delete a mission by ID
  Future<int> deleteMission(int missionId) async {
    return await db.delete(
      'missionsdb',
      where: 'missionId = ?',
      whereArgs: [missionId],
    );
  }


  /// Count the number of missions by category
  Future<int> countMissionsByCategory(String category) async {
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM missionsdb WHERE category = ?',
      [category],
    );

    return result.first['count'] as int;
  }


  /// Check if a mission exists by title
  Future<bool> missionExists(String title) async {
    final List<Map<String, dynamic>> result = await db.query(
      'missionsdb',
      where: 'title = ?',
      whereArgs: [title],
    );

    return result.isNotEmpty;
  }
}
