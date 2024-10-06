import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_parent/Screen/profile_screen.dart';
import 'package:go_parent/Widgets/side_menu.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});
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
      // bottom navigation bar
      bottomNavigationBar: Obx(
        () => NavigationBar(
            height: 80,
            elevation: 0,
            selectedIndex: cont.selectedIndex.value,
            onDestinationSelected: (index) => cont.selectedIndex.value = index,
            destinations: [
              NavigationDestination(icon: Icon(Icons.home), label: "home"),
              NavigationDestination(icon: Icon(Icons.task), label: "home"),
              NavigationDestination(icon: Icon(Icons.settings), label: "home"),
              NavigationDestination(
                  icon: Icon(Icons.person_2_rounded), label: "home"),
            ]),
      ),

      // appbar
      appBar: AppBar(title: Text("Home")),
      //Drawer
      drawer: SideMenu(),

      //obx
      body: Obx(() => cont.screens[cont.selectedIndex.value]),
    );
  }
}

// screen navigator
class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const Logout(),
    Container(
      color: Colors.blue,
    ),
    Container(
      color: Colors.yellow,
    ),
    Container(
      color: Colors.red,
    )
  ];
}

class thelperfunction {
  static bool isdarkmode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }
}
