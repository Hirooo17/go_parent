import 'package:flutter/material.dart';

class MissionScreen extends StatefulWidget {
  const MissionScreen({super.key});

  @override
  State<MissionScreen> createState() => _MissionScreenState();
}

class _MissionScreenState extends State<MissionScreen> {
  final List<bool> _isMissionCompleted = [false, false];
  final List<bool> _isMissionCompleted2 = [false, false];
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(child: Text("Missions")),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          // First mission
          Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Icon(
                      _isMissionCompleted[0]
                          ? Icons.check_circle
                          : Icons.check_circle_outline,
                      color:
                          _isMissionCompleted[0] ? Colors.green : Colors.grey,
                    ),
                    title: Text('Read with your child'),
                    subtitle: Text('Spend 20 minutes reading together'),
                    trailing: Text('Reward: 50 points'),
                  ),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Text('Mission Progress:$progress' ),
                      SizedBox(height: 5),
                      // LinearProgressIndicator(value: progress),
                    ],
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isMissionCompleted[0] = !_isMissionCompleted[0];
                      });
                    },
                    child: Text('Complete Mission'),
                  ),
                ],
              ),
            ),
          ),

          // Second mission
          Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Icon(
                      _isMissionCompleted2[0]
                          ? Icons.check_circle
                          : Icons.check_circle_outline,
                      color:
                          _isMissionCompleted2[0] ? Colors.green : Colors.grey,
                    ),
                    title: Text('Go for a walk with your child'),
                    subtitle: Text('Walk for 30 minutes'),
                    trailing: Text('Reward: 75 points'),
                  ),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text('Mission Progress: 20%'),
                      SizedBox(height: 5),

                      // LinearProgressIndicator(value: 0.2),
                    ],
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isMissionCompleted2[0] = !_isMissionCompleted2[0];
                      });
                    },
                    child: Text('Complete Mission'),
                  ),
                ],
              ),
            ),
          ),

          // Add more missions in the same format if needed
        ],
      ),
    );
  }
}
