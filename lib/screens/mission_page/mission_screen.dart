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
    return Column(
      children: [

        Text("data"),

        Expanded(
          child: TabControllerWidget()
          ),
      ],
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
