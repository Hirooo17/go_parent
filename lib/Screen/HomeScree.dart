import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_parent/LoginPage/login.dart';
import 'package:go_parent/Screen/logout.dart';
import 'package:go_parent/Widgets/button.dart';
import 'package:go_parent/authentication/auth.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final AuthMethod _authMethod = AuthMethod(); // Instantiate AuthMethod

  @override
  Widget build(BuildContext context) {

    final cont = Get.put(NavigationController());
    final darkmode = thelperfunction.isdarkmode(context);
  


    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: cont.selectedIndex.value,
          //backgroundColor: darkmode? Colors.black : Colors.white,
          //indicatorColor: darkmode? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(1),
        
          onDestinationSelected: (index) => cont.selectedIndex.value = index,
          destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: "home"),
          NavigationDestination(icon: Icon(Icons.task), label: "home"),
          NavigationDestination(icon: Icon(Icons.settings), label: "home"),
          NavigationDestination(icon: Icon(Icons.person_2_rounded), label: "home"),
          ]
          ),
      ),
    
      

      // appbar
      appBar: AppBar(title: Text("Home")),


      //obx
     body: Obx(()=> cont.screens[cont.selectedIndex.value]),



      
    );




   
  }


  
}
// screen navigator
class NavigationController extends  GetxController{
  final Rx<int> selectedIndex = 0.obs;


  final screens = [
    const Logout(),
    Container(color: Colors.blue,),
    Container(color: Colors.yellow,),
    Container(color: Colors.red,)];
}

class thelperfunction {
  static bool isdarkmode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }
}
