import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_parent/Screen/mission_screen.dart';
import 'package:go_parent/Screen/profile_screen.dart';
import 'package:go_parent/Screen/prototypeMissionGraph.dart';
import 'package:go_parent/Widgets/side_menu.dart';

class Homescreen extends StatefulWidget {
    final String username;


  
  const Homescreen({
    super.key,
    required this.username
  });
  static String id = 'home_screen';
 

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? loggedInUser;
  

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        setState(() {
          loggedInUser = user;
        });
        print('Logged in user: ${loggedInUser!.email}');
      }
    } catch (e) {
      print('Error getting current user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cont = Get.put(NavigationController());

    return Scaffold(
      // Bottom Navigation Bar
      bottomNavigationBar: Obx(
        () => NavigationBar(
            height: 80,
            elevation: 0,
            selectedIndex: cont.selectedIndex.value,
            onDestinationSelected: (index) => cont.selectedIndex.value = index,
            destinations: [
              NavigationDestination(icon: Icon(Icons.home), label: "Home"),
              NavigationDestination(
                  icon: Icon(Icons.task_rounded), label: "Missions"),
              NavigationDestination(icon: Icon(Icons.settings), label: "Settings"),
              NavigationDestination(
                  icon: Icon(Icons.person_2_rounded), label: "Profile"),
            ]),
      ),

      // AppBar
      appBar: AppBar(title: Text("Home")),

      // Drawer
      drawer: SideMenu(username: widget.username),

      // Body
      body: Obx(() {
        return IndexedStack(
          index: cont.selectedIndex.value, // Maintain the selected index
          children: cont.screens, // The screens to display
        );
      }),
    );
  }
}

// Screen Navigator
class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const Logout(),
    MissionScreen(), // This will display the mission screen
    MissionProgressGraph( missionPoints: [50, 90, 130, 160, 200],), // Dashboard widget for mission data
    Container(
      color: Colors.red,
    )
  ];
}

// Dashboard widget for Missions
class MissionDashboard extends StatelessWidget {
  const MissionDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // Example dummy mission data for the dashboard
    int currentScore = 120; // This would be dynamically fetched
    int completedMissions = 5; // This would also be fetched from the mission screen

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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(),
              const SizedBox(height: 16),
              Text(
                'Mission Progress:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: completedMissions / 10, // Assume 10 total missions
                backgroundColor: Colors.green[100],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
