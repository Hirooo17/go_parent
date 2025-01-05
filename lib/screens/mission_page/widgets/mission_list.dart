// import 'package:flutter/material.dart';
// import 'package:go_parent/screens/mission_page/mission_brain.dart';
// import 'package:go_parent/services/database/local/helpers/missions_helper.dart';
// import 'package:go_parent/services/database/local/models/missions_model.dart';
// import 'package:go_parent/services/database/local/sqlite.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// // class MissionList extends StatelessWidget {
// //   final MissionHelper missionHelper;

// //   MissionList(this.missionHelper);

// //   @override
// //   Widget build(BuildContext context) {


// //     return ListView.builder(
// //       itemCount: 20,
// //       itemBuilder: (context, index) {
// //         return ListTile(
// //           title: Text('Mission ${index + 1}'),
// //           subtitle: Text('Mission ${index + 1} description'),
// //           trailing: Icon(Icons.check_circle),
// //         );
// //       },
// //     );


// //   }
// // }

// class MissionList extends StatelessWidget {
//   final List<MissionModel> missions;

//   const MissionList({
//     Key? key,
//     required this.missions,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: missions.length,
//       itemBuilder: (context, index) {
//         final mission = missions[index];
//         return ListTile(
//           title: Text(mission.title),
//           subtitle: Text(mission.content),
//           trailing: Icon(
//             mission.isCompleted ? Icons.check_circle : Icons.circle_outlined,
//             color: mission.isCompleted ? Colors.green : Colors.grey,
//           ),
//         );
//       },
//     );
//   }
// }


// class TabControllerWidget extends StatefulWidget {

//   @override
//   _TabControllerWidgetState createState() => _TabControllerWidgetState();
// }

// class _TabControllerWidgetState extends State<TabControllerWidget> {
//   late MissionBrain _missionBrain;
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _initializeMissionBrain();
//   }

//   Future<void> _initializeMissionBrain() async {
//     // Initialize database
//     final db = await openDatabase('your_database.db');
//     final missionHelper = MissionHelper(db);

//     // Create MissionBrain
//     _missionBrain = MissionBrain(missionHelper);

//     // Load missions
//     await _loadMissions();
//   }

//   Future<void> _loadMissions() async {
//     setState(() {
//       _isLoading = true;
//     });

//     await _missionBrain.loadAllMissions();

//     setState(() {
//       _isLoading = false;
//     });
//   }







//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 1,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Go Missions'),
//           bottom: const TabBar(
//             tabs: [Tab(text: 'Missions')],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             Column(
//               children: [
//                 MissionList(missions: _missionBrain.missions),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
