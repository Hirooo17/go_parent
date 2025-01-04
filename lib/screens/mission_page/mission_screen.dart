import 'package:flutter/material.dart';
import 'package:go_parent/Screen/prototypeMissionGraph.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_parent/services/database/local/sqlite.dart';
import 'dart:io';
import 'widgets/tab_controller.dart';

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

  @override
  void initState() {
    super.initState();
    _loadUserBabies();
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
          child: TabControllerWidget(
          ),
        ),
      ],
    );
  }
}
