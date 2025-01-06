import 'package:go_parent/services/database/local/helpers/baby_helper.dart';
import 'package:go_parent/services/database/local/helpers/missions_helper.dart';
import 'package:go_parent/services/database/local/models/missions_model.dart';

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



}
