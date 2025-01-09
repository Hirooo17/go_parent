import 'package:go_parent/services/database/local/helpers/baby_helper.dart';
import 'package:go_parent/services/database/local/helpers/missions_helper.dart';
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

    // Retrieve missions for all babies linked to the logged-in user
  Future<List<MissionModel>> getMissionsForUserBabies() async {
    // Retrieve the logged-in user's ID from the UserSession
    final userId = UserSession().userId;

    if (userId == null) {
      print("[getMissionsForUserBabies] No user is logged in.");
      return [];
    }

    print("[getMissionsForUserBabies] Fetching missions for userId: $userId");

    // Retrieve all babies linked to the user
    final babies = await babyHelper.getBabiesByUserId(userId);

    if (babies.isEmpty) {
      print("[getMissionsForUserBabies] No babies found for userId: $userId");
      return [];
    }

    print("[getMissionsForUserBabies] Found ${babies.length} babies for userId: $userId");

    // Fetch missions for each baby's age and combine the results
    List<MissionModel> allMissions = [];
    for (var baby in babies) {
      final babyAgeInMonths = baby.babyAge; // Assuming `ageInMonths` is a property of BabyModel
    /// print("[getMissionsForUserBabies] Fetching missions for babyId: ${baby.id} with age: $babyAgeInMonths months");

      final missions = await missionHelper.getMissionsByBabyMonthAge(babyAgeInMonths);
      allMissions.addAll(missions);
    }

    print("[getMissionsForUserBabies] Total missions fetched: ${allMissions.length}");
    return allMissions;
  }




}
