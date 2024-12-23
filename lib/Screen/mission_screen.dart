import 'package:flutter/material.dart';
import 'package:go_parent/Screen/prototypeMissionGraph.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_parent/services/database/local/sqlite.dart';
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
  int totalPoints = 0;

  List<XFile?> _images = List.generate(20, (index) => null);

  Future<void> _pickImageForMission(int missionIndex) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
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
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          elevation: 8,
          backgroundColor: Colors.teal,
          title: Column(
            children: [
              // Inside the AppBar or as a separate button on MissionScreen
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MissionProgressGraph(
                        missionPoints: [
                          50,
                          90,
                          130,
                          160,
                          200
                        ], // Example points list
                      ),
                    ),
                  );
                },
                child: const Text('View Progress Graph'),
              ),

              const Text(
                "Missions",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              Text(
                'Total Points: $totalPoints',
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
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
            _buildMissionList(
              missions: [
                {
                  'title': 'Read with your child',
                  'reward': 50,
                  'subtitle': 'Spend 20 minutes reading together'
                },
                {
                  'title': 'Help your child clean their room',
                  'reward': 40,
                  'subtitle': 'Organize toys and clothes'
                },
                {
                  'title': 'Teach your child basic hygiene',
                  'reward': 30,
                  'subtitle': 'Explain handwashing and brushing teeth'
                },
                {
                  'title': 'Prepare a healthy meal together',
                  'reward': 70,
                  'subtitle': 'Cook a nutritious meal with your child'
                },
                {
                  'title': 'Do laundry together',
                  'reward': 60,
                  'subtitle': 'Show how to sort and fold clothes'
                },
              ],
              missionCompleted: _isMissionCompleted,
              imageIndexStart: 0,
            ),
            _buildMissionList(
              missions: [
                {
                  'title': 'Solve a puzzle with your child',
                  'reward': 80,
                  'subtitle': 'Complete a puzzle together'
                },
                {
                  'title': 'Draw and color a picture',
                  'reward': 50,
                  'subtitle': 'Create art with your child'
                },
                {
                  'title': 'Teach your child numbers 1-10',
                  'reward': 60,
                  'subtitle': 'Help them recognize numbers'
                },
                {
                  'title': 'Do a science experiment',
                  'reward': 90,
                  'subtitle': 'Perform a safe experiment together'
                },
                {
                  'title': 'Teach your child new words',
                  'reward': 70,
                  'subtitle': 'Expand vocabulary by learning words'
                },
              ],
              missionCompleted: _isMissionCompleted2,
              imageIndexStart: 5,
            ),
            _buildMissionList(
              missions: [
                {
                  'title': 'Play catch outside',
                  'reward': 50,
                  'subtitle': 'Throw and catch a ball for 30 minutes'
                },
                {
                  'title': 'Go for a walk in the park',
                  'reward': 75,
                  'subtitle': 'Spend 30 minutes walking'
                },
                {
                  'title': 'Fly a kite together',
                  'reward': 60,
                  'subtitle': 'Fly a kite outdoors'
                },
                {
                  'title': 'Ride a bike with your child',
                  'reward': 80,
                  'subtitle': 'Spend 40 minutes riding bikes'
                },
                {
                  'title': 'Play a sport together',
                  'reward': 90,
                  'subtitle': 'Play soccer or basketball'
                },
              ],
              missionCompleted: _isMissionCompleted3,
              imageIndexStart: 10,
            ),
            _buildMissionList(
              missions: [
                {
                  'title': 'Do a fun activity together',
                  'reward': 50,
                  'subtitle': 'Spend time doing something creative'
                },
                {
                  'title': 'Play a board game',
                  'reward': 60,
                  'subtitle': 'Choose a game and play for 30 minutes'
                },
                {
                  'title': 'Build a Lego structure',
                  'reward': 70,
                  'subtitle': 'Use Legos to create a building or object'
                },
                {
                  'title': 'Plan a family picnic',
                  'reward': 80,
                  'subtitle': 'Prepare food and have a picnic together'
                },
                {
                  'title': 'Watch an educational video',
                  'reward': 90,
                  'subtitle': 'Learn something new from a video'
                },
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
      padding: const EdgeInsets.all(10),
      itemCount: missions.length,
      itemBuilder: (context, index) {
        final mission = missions[index];
        final currentIndex = imageIndexStart + index;
        return Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      missionCompleted[index] && _images[currentIndex] != null
                          ? Icons.verified
                          : Icons.circle_outlined,
                      color: missionCompleted[index] &&
                              _images[currentIndex] != null
                          ? Colors.green
                          : Colors.grey,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        mission['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Text(
                      '+${mission['reward']} pts',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.teal[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  mission['subtitle'],
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: !missionCompleted[index]
                          ? () {
                              setState(() {
                                totalPoints += (mission['reward'] as int);
                                missionCompleted[index] = true;
                              });
                            }
                          : null,
                      icon: const Icon(Icons.done),
                      label: Text(
                        missionCompleted[index] ? 'Completed' : 'Complete',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => _pickImageForMission(currentIndex),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Submit Photo'),
                    ),
                  ],
                ),
                if (_images[currentIndex] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(_images[currentIndex]!.path),
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
