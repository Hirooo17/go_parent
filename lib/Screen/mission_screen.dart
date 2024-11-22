// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Add this for image picking
import 'package:go_parent/Database/sqlite.dart';
import 'dart:io';

class MissionScreen extends StatefulWidget {
  const MissionScreen({super.key});

  @override
  State<MissionScreen> createState() => _MissionScreenState();
}

class _MissionScreenState extends State<MissionScreen> {
  final DatabaseService _databaseService = DatabaseService.instance;

  final List<bool> _isMissionCompleted = List.generate(5, (index) => false);
  final List<bool> _isMissionCompleted2 = List.generate(5, (index) => false);
  final List<bool> _isMissionCompleted3 = List.generate(5, (index) => false);
  final List<bool> _isMissionCompleted4 = List.generate(5, (index) => false);

  double progress = 0;
  int totalPoints = 0; // For tracking points

  // Separate image variables for each mission
  List<XFile?> _images = List.generate(20, (index) => null);

  // Method to pick an image for a specific mission
  Future<void> _pickImageForMission(int missionIndex) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera); // or ImageSource.gallery
    if (pickedFile != null) {
      setState(() {
        _images[missionIndex] = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Center(
              child: Column(
            children: [
              Text("Missions"),
              Text('Points: $totalPoints', style: TextStyle(fontSize: 14)),
            ],
          )),
          bottom: TabBar(
            tabs: [
              Tab(text: "Daily Routines"),
              Tab(text: "Learning Activities"),
              Tab(text: "Outdoor Play"),
              Tab(text: "Sample"),
            ],
          ),
          automaticallyImplyLeading: false,
        ),
        body: TabBarView(
          children: [
            // Daily Routines tab
            _buildMissionList(
              missions: [
                {'title': 'Read with your child', 'reward': 50, 'subtitle': 'Spend 20 minutes reading together'},
                {'title': 'Help your child clean their room', 'reward': 40, 'subtitle': 'Organize toys and clothes'},
                {'title': 'Teach your child basic hygiene', 'reward': 30, 'subtitle': 'Explain handwashing and brushing teeth'},
                {'title': 'Prepare a healthy meal together', 'reward': 70, 'subtitle': 'Cook a nutritious meal with your child'},
                {'title': 'Do laundry together', 'reward': 60, 'subtitle': 'Show how to sort and fold clothes'},
              ],
              missionCompleted: _isMissionCompleted,
              imageIndexStart: 0,
            ),

            // Learning Activities tab
            _buildMissionList(
              missions: [
                {'title': 'Solve a puzzle with your child', 'reward': 80, 'subtitle': 'Complete a puzzle together'},
                {'title': 'Draw and color a picture', 'reward': 50, 'subtitle': 'Create art with your child'},
                {'title': 'Teach your child numbers 1-10', 'reward': 60, 'subtitle': 'Help them recognize numbers'},
                {'title': 'Do a science experiment', 'reward': 90, 'subtitle': 'Perform a safe experiment together'},
                {'title': 'Teach your child new words', 'reward': 70, 'subtitle': 'Expand vocabulary by learning words'},
              ],
              missionCompleted: _isMissionCompleted2,
              imageIndexStart: 5,
            ),

            // Outdoor Play tab
            _buildMissionList(
              missions: [
                {'title': 'Play catch outside', 'reward': 50, 'subtitle': 'Throw and catch a ball for 30 minutes'},
                {'title': 'Go for a walk in the park', 'reward': 75, 'subtitle': 'Spend 30 minutes walking'},
                {'title': 'Fly a kite together', 'reward': 60, 'subtitle': 'Fly a kite outdoors'},
                {'title': 'Ride a bike with your child', 'reward': 80, 'subtitle': 'Spend 40 minutes riding bikes'},
                {'title': 'Play a sport together', 'reward': 90, 'subtitle': 'Play soccer or basketball'},
              ],
              missionCompleted: _isMissionCompleted3,
              imageIndexStart: 10,
            ),

            // Sample tab
            _buildMissionList(
              missions: [
                {'title': 'Do a fun activity together', 'reward': 50, 'subtitle': 'Spend time doing something creative'},
                {'title': 'Play a board game', 'reward': 60, 'subtitle': 'Choose a game and play for 30 minutes'},
                {'title': 'Build a Lego structure', 'reward': 70, 'subtitle': 'Use Legos to create a building or object'},
                {'title': 'Plan a family picnic', 'reward': 80, 'subtitle': 'Prepare food and have a picnic together'},
                {'title': 'Watch an educational video', 'reward': 90, 'subtitle': 'Learn something new from a video'},
              ],
              missionCompleted: _isMissionCompleted4,
              imageIndexStart: 15,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionList({
    required List<Map<String, dynamic>> missions,
    required List<bool> missionCompleted,
    required int imageIndexStart,
  }) {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: missions.length,
      itemBuilder: (context, index) {
        final mission = missions[index];
        final currentIndex = imageIndexStart + index;
        return Card(
          elevation: 4,
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Icon(
                    missionCompleted[index] && _images[currentIndex] != null
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    color: missionCompleted[index] && _images[currentIndex] != null
                        ? Colors.green
                        : Colors.grey,
                  ),
                  title: Text(mission['title']),
                  subtitle: Text(mission['subtitle']),
                  trailing: Text('Reward: ${mission['reward']} points'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: !missionCompleted[index]
                      ? () {
                          setState(() {
                            totalPoints += (mission['reward'] as int);

                            missionCompleted[index] = true;
                          });
                        }
                      : null, // Disable button if mission is completed
                  child: Text(missionCompleted[index]
                      ? 'Mission Completed'
                      : 'Complete Mission'),
                ),
                ElevatedButton(
                  onPressed: () => _pickImageForMission(currentIndex),
                  child: Text('Submit Photo'),
                ),
                if (_images[currentIndex] != null)
                  Image.file(File(_images[currentIndex]!.path)),
              ],
            ),
          ),
        );
      },
    );
  }
}
