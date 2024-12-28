import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_parent/screens/mission_page/mission_screen.dart';
import 'package:go_parent/Screen/profile_screen.dart';
import 'package:go_parent/Screen/prototypeMissionGraph.dart';
import 'package:go_parent/widgets/side_menu.dart';

class Homescreen extends StatefulWidget {
  final String username;
  static String id = 'home_screen';

  const Homescreen({
    super.key,
    required this.username
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
    final cont = Get.put(NavigationController());

    return Scaffold(
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

      appBar: AppBar(title: Text("Home")),
      drawer: SideMenu(username: widget.username),
      body: Obx(() {
        return IndexedStack(
          index: cont.selectedIndex.value, // Maintain the selected index
          children: cont.screens, // The screens to display
        );
      }),
    );
  }
}

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

class MissionDashboard extends StatelessWidget {
  const MissionDashboard({super.key});

  @override
  Widget build(BuildContext context) {
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
                value: completedMissions / 10,
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
