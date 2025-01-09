
import 'package:flutter/material.dart';
import 'package:go_parent/screens/mission_page/mission_brain.dart';
import 'package:go_parent/services/database/local/models/baby_model.dart';
import 'package:go_parent/services/database/local/models/missions_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../services/database/local/helpers/baby_helper.dart';
import '../../services/database/local/helpers/missions_helper.dart';


class MissionScreen extends StatefulWidget {
  const MissionScreen({super.key});
  static String id = "mission_screen";

  @override
  State<MissionScreen> createState() => _MissionScreenState();
}

class _MissionScreenState extends State<MissionScreen> {
  double progress = 0;
  int totalPoints = 0;

  Map<String, dynamic>? _selectedBaby;
  // List<Map<String, dynamic>> _missions = [];




    List<BabyModel> _babies = [];
  int? _selectedBabyAge; // The selected value, null if nothing selected yet











  late MissionBrain _missionBrain;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserBabies();
    _initializeMissionBrain();
  }


    Future<void> _loadUserBabies() async {
    final babies = await _missionBrain.getBabiesForUser();
    setState(() {
      _babies = babies;
      _selectedBabyAge = _babies.isNotEmpty ? _babies.first.babyAge : null;
    });
  }









  Future<void> _initializeMissionBrain() async {
    // Initialize database
    final db = await openDatabase('goparent_v2.db');
    final missionHelper = MissionHelper(db);
    final babyHelper = BabyHelper(db);

    // Create MissionBrain
    _missionBrain = MissionBrain(missionHelper, babyHelper);

    // Load missions
    await _loadMissions();
  }

  Future<void> _loadMissions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _missionBrain.loadAllMissions();
      print("Missions loaded successfully");
    } catch (e) {
      print("Error loading missions: $e");
    }

    setState(() {
      _isLoading = false;
    });
  }





//   Future<void> _loadMissionsForSelectedBaby() async {
//     if (_selectedBaby != null) {
//       int babyAge = _selectedBaby!['babyAge'];
//       _missions = await missionBrain.getMissionsByBabyMonthAge(babyAge, babyAge);
//       _missionCompleted = List.generate(_missions.length, (index) => _missions[index]['isCompleted']);
//       setState(() {});
//     }
//   }


///
///
//

  // Future<void> _pickImageForMission(int missionIndex) async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.camera);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _images[missionIndex] = pickedFile;
  //     });
  //   }
  // }

  // void _completeMission(int missionIndex) {
  //   setState(() {
  //     _missionCompleted[missionIndex] = true;
  //     _missions[missionIndex]['isCompleted'] = true;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // if (_selectedBaby != null)
        //   DropdownButton<Map<String, dynamic>>(
        //     value: _selectedBaby,
        //     items: _babies.map((baby) {
        //       return DropdownMenuItem<Map<String, dynamic>>(
        //         value: baby,
        //         child: Text(baby['babyName']),
        //       );
        //     }).toList(),
        //     onChanged: (value) {
        //       setState(() {
        //         _selectedBaby = value;
        //        // _loadMissionsForSelectedBaby();
        //       });
        //     },
        //   ),

       if (_babies.isNotEmpty)
  BabyDropdownMenu(
    babies: _babies,
    onBabySelected: (BabyModel baby) {
      setState(() {
        _selectedBabyAge = baby.babyAge;
      });
      // You can add additional logic here to load missions for the selected baby
    },
  ),





        Text("data"),
        Expanded(
          child: DefaultTabController(
            length: 1,
            child: Scaffold(
              backgroundColor: Colors.grey[200],
              appBar: AppBar(
                elevation: 8,
                backgroundColor: Colors.teal,
                title: const Text('Go Missions'),
                bottom: const TabBar(
                  tabs: [
                    Tab(text: 'Missions'),
                  ],
                ),
              ),
              body: _isLoading
                ? Center(child: CircularProgressIndicator())
                : TabBarView(
                    children: [
                      Column(
                        children: [
                          MissionList(missions: _missionBrain.missions),
                        ],
                      ),
                    ],
                  ),
            ),
          ),




        ),
      ],
    );
  }
}







class BabyDropdownMenu extends StatefulWidget {
  final List<BabyModel> babies;
  final Function(BabyModel) onBabySelected;

  const BabyDropdownMenu({
    super.key,
    required this.babies,
    required this.onBabySelected,
  });

  @override
  State<BabyDropdownMenu> createState() => _BabyDropdownMenuState();
}

class _BabyDropdownMenuState extends State<BabyDropdownMenu> {
  late BabyModel selectedBaby;

  @override
  void initState() {
    super.initState();
    if (widget.babies.isNotEmpty) {
      selectedBaby = widget.babies.first;
    }
  }

  // Convert BabyModel to DropdownMenuEntry
  List<DropdownMenuEntry<BabyModel>> _createMenuEntries() {
    return widget.babies.map<DropdownMenuEntry<BabyModel>>((BabyModel baby) {
      return DropdownMenuEntry<BabyModel>(
        value: baby,
        label: '${baby.babyName} (${baby.babyAge} months)',
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.babies.isEmpty) {
      return const Text('No babies available');
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownMenu<BabyModel>(
        initialSelection: widget.babies.first,
        onSelected: (BabyModel? value) {
          if (value != null) {
            setState(() {
              selectedBaby = value;
            });
            widget.onBabySelected(value);
          }
        },
        dropdownMenuEntries: _createMenuEntries(),
        width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
        menuStyle: MenuStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          elevation: MaterialStateProperty.all(8),
        ),
        textStyle: const TextStyle(fontSize: 16),
      ),
    );
  }
}









class MissionList extends StatelessWidget {
  final List<MissionModel> missions;

  const MissionList({
    Key? key,
    required this.missions,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Add this debug print
    print("Building MissionList with ${missions.length} missions");

    if (missions.isEmpty) {
      return const Center(
        child: Text('No missions available'),
      );
    }

    return Expanded(

      child: ListView.builder(
        itemCount: missions.length,
        itemBuilder: (context, index) {
          final mission = missions[index];
          if (mission == null) {
            print("Null mission at index $index");
            return const SizedBox.shrink();
          }

          return Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), ),
            margin: const EdgeInsets.all(10.0),

            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  ListTile(
                    title: Text(mission.title ,
                          style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    subtitle: Text(mission.content,
                    style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,), ),
                    trailing: Icon(
                      mission.isCompleted ? Icons.circle_outlined : Icons.check_circle ,
                      color: mission.isCompleted ? Colors.green : Colors.grey,
                    ),
                  ),

                  const SizedBox(width: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => print("pressedllolol"),
                      icon: const Icon(Icons.camera_alt, color: Colors.white,),
                      label: const Text('Submit Photo',  style: TextStyle(color: Colors.white),),
                    ),

                ],
              ),
            ),
          );
        },
      ),
    );


  }
}
