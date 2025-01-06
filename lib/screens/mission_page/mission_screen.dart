import 'package:flutter/material.dart';
import 'package:go_parent/Screen/prototypeMissionGraph.dart';
import 'package:go_parent/services/database/local/helpers/missions_helper.dart';
import 'package:go_parent/services/database/local/models/missions_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_parent/services/database/local/sqlite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';
import 'widgets/tab_controller.dart';
import 'package:go_parent/screens/mission_page/mission_brain.dart';

class MissionScreen extends StatefulWidget {
  const MissionScreen({super.key});
  static String id = "mission_screen";

  @override
  State<MissionScreen> createState() => _MissionScreenState();
}

class _MissionScreenState extends State<MissionScreen> {
  double progress = 0;
  int totalPoints = 0;

  List<XFile?> _images = List.generate(20, (index) => null);
  List<bool> _missionCompleted = [];

  List<Map<String, dynamic>> _babies = [];
  Map<String, dynamic>? _selectedBaby;
  List<Map<String, dynamic>> _missions = [];


  late MissionBrain _missionBrain;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserBabies();
    _initializeMissionBrain();
  }





    Future<void> _initializeMissionBrain() async {
    // Initialize database
    final db = await openDatabase('goparent_v2.db');
    final missionHelper = MissionHelper(db);

    // Create MissionBrain
    _missionBrain = MissionBrain(missionHelper);

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





  Future<void> _loadUserBabies() async {
    // Assuming userId is available
    int userId = 1; // Replace with actual userId
    _babies = await DatabaseService.instance.getUserBabies(userId);
    if (_babies.isNotEmpty) {
      setState(() {
        _selectedBaby = _babies.first;
        _loadMissionsForSelectedBaby();
      });
    }
  }

  Future<void> _loadMissionsForSelectedBaby() async {
    if (_selectedBaby != null) {
      int babyAge = _selectedBaby!['babyAge'];
      _missions = await DatabaseService.instance.getMissionsForAge(babyAge, babyAge);
      _missionCompleted = List.generate(_missions.length, (index) => _missions[index]['isCompleted']);
      setState(() {});
    }
  }

  Future<void> _pickImageForMission(int missionIndex) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _images[missionIndex] = pickedFile;
      });
    }
  }

  void _completeMission(int missionIndex) {
    setState(() {
      _missionCompleted[missionIndex] = true;
      _missions[missionIndex]['isCompleted'] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_selectedBaby != null)
          DropdownButton<Map<String, dynamic>>(
            value: _selectedBaby,
            items: _babies.map((baby) {
              return DropdownMenuItem<Map<String, dynamic>>(
                value: baby,
                child: Text(baby['babyName']),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedBaby = value;
                _loadMissionsForSelectedBaby();
              });
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
