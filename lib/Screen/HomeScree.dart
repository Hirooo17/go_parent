// ignore: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_parent/Screen/logout.dart';
import 'package:go_parent/Screen/settings.dart';
import 'package:go_parent/Widgets/side_menu.dart';
//import 'package:go_parent/authentication/auth.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  
   // Index to track the selected drawer item
  

  @override
  Widget build(BuildContext context) {
    final cont = Get.put(NavigationController());
   

  // Function to update the selected index
 

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
       // Drawer
     drawer: SideMenu(),

      //obx
      body: Obx(() => cont.screens[cont.selectedIndex.value]),
      
    );
  }
}

// screen navigator
class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
 final Rx<int> selectedDrawerIndex = 0.obs;  // Index for drawer navigation
  final screens = [
    const Logout(),
    const Settings(),
    Container(
      color: Colors.yellow,
    ),
    Container(
      color: Colors.red,
    )
  ];
final List<Widget> drawerScreens = [
    Container(
      color: Colors.yellow,
    ),
    const Logout(), 
   
  ];

  
}

class thelperfunction {
  static bool isdarkmode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }
}
