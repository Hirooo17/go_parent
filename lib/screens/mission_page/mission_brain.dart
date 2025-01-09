import 'package:go_parent/services/database/local/helpers/baby_helper.dart';
import 'package:go_parent/services/database/local/helpers/missions_helper.dart';
import 'package:go_parent/services/database/local/models/baby_model.dart';
import 'package:go_parent/services/database/local/models/missions_model.dart';
import 'package:go_parent/utilities/user_session.dart';
class MissionBrain {
  final MissionHelper missionHelper;
  final BabyHelper babyHelper;
  List<MissionModel> _missions = [];
  MissionBrain(this.missionHelper, this.babyHelper);
  List<MissionModel> get missions => _missions;
//Missions funcions
  Future<void> loadAllMissions() async {
    try {
      _missions = await missionHelper.getAllMissions();
    } catch (e) {
      print('Error loading missions: $e');
      _missions = [];
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
    //baby functions getMissionsByBabyMonthAge
// Retrieve all babies linked to the logged-in user
Future<List<BabyModel>> getBabiesForUser() async {
  // Retrieve the logged-in user's ID from the UserSession
  final userId = 1; // This should be replaced with UserSession().userId when implementing real user session logic
  if (userId == null) {
    print("[getBabiesForUser] No user is logged in.");
    return [];
  }
  print("[getBabiesForUser] Fetching babies for userId: $userId");
  // Retrieve all babies linked to the user
  final babies = await babyHelper.getBabiesByUserId(userId);
  if (babies.isEmpty) {
    print("[getBabiesForUser] No babies found for userId: $userId");
    return [];
  }
  print("[getBabiesForUser] Found ${babies.length} babies for userId: $userId");
  return babies;
}
}