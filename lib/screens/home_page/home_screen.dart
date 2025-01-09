import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_parent/Beta%20Testing%20Folder/note_screen.dart';
import 'package:go_parent/Screen/dashboard.dart';
import 'package:go_parent/Screen/profile_screen.dart';
import 'package:go_parent/Screen/prototypeMissionGraph.dart';
import 'package:go_parent/Screen/view%20profile/viewprofile.dart';
import 'package:go_parent/screens/mission_page/mission_screen.dart';
import 'package:go_parent/widgets/side_menu.dart';

class Homescreen extends StatefulWidget {
  final String username;
  static String id = 'home_screen';
  final int userId;

  const Homescreen({
    super.key,
    required this.username,
    required this.userId,
  });

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cont = Get.put(NavigationController(username: widget.username, userId: widget.userId));

    return Scaffold(
      // Bottom Navigation Bar
      bottomNavigationBar: Obx(
        () => NavigationBar(
            height: 80,
            elevation: 0,
            selectedIndex: cont.selectedIndex.value,
            onDestinationSelected: (index) => cont.selectedIndex.value = index,
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: "Home"),
              NavigationDestination(icon: Icon(Icons.task_rounded), label: "Missions"),
              NavigationDestination(icon: Icon(Icons.person_2_rounded), label: "Profile"),
              
            ]),
            
      ),

      // AppBar
      appBar: AppBar(title: const Text("Home")),

      // Drawer
      drawer: SideMenu(username: widget.username),

      // Body
      body: Obx(() {
        return IndexedStack(
          index: cont.selectedIndex.value,
          children: cont.screens,
        );
      }),
    );
  }
}

// Screen Navigator
class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final String username;
  final int userId;

  NavigationController({required this.username, required this.userId});

  late final List<Widget> screens;

  @override
  void onInit() {
    super.onInit();
    screens = [
      Logout(username: username, userId: userId),
      MissionDashboard(),
      profileviewer(),
    ];
  }
}









// Dashboard widget for Missions
class MissionDashboard extends StatelessWidget {
  const MissionDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // Example dummy mission data for the dashboard
    int currentScore = 120;
    int completedMissions = 5;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mission Dashboard',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Current Score:',
                    style: TextStyle(fontSize: 18, color: Colors.green[700]),
                  ),
                  Text(
                    '$currentScore',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Completed Missions:',
                    style: TextStyle(fontSize: 18, color: Colors.green[700]),
                  ),
                  Text(
                    '$completedMissions',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'Mission Progress:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: completedMissions / 10,
                backgroundColor: Colors.green[100],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 