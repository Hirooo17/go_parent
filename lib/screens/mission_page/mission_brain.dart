import 'package:go_parent/services/database/local/helpers/missions_helper.dart';
import 'package:go_parent/services/database/local/models/missions_model.dart';

class MissionBrain {
  final MissionHelper missionHelper;
  List<MissionModel> _missions = [];

  MissionBrain(this.missionHelper);

  List<MissionModel> get missions => _missions;


  Future<void> loadAllMissions() async {
    try {
      _missions = await missionHelper.getAllMissions();
    } catch (e) {
      print('Error loading missions: $e');
      _missions = []; // Reset to empty list on error
    }
  }

  Future<List<MissionModel>> getMissionsByCategory(String category) async {
    try {
      return await missionHelper.getMissionsByCategory(category);
    } catch (e) {
      print('Error loading missions by category: $e');
      return [];
    }
  }

  // Get missions by age range
  Future<List<MissionModel>> getMissionsByAge(int minAge, int maxAge) async {
    try {
      return await missionHelper.getMissionsByAge(minAge, maxAge);
    } catch (e) {
      print('Error loading missions by age: $e');
      return [];
    }
  }

  // Get completed/incomplete missions
  Future<List<MissionModel>> getMissionsByCompletion(bool isCompleted) async {
    try {
      return await missionHelper.getMissionsByCompletion(isCompleted);
    } catch (e) {
      print('Error loading missions by completion: $e');
      return [];
    }
}
}
