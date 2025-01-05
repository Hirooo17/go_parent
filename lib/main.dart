// ignore_for_file: unused_import, duplicate_import

//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'package:go_parent/services/database/firebase_options.dart';
import 'package:go_parent/screens/login_page/login_screen.dart';
import 'package:go_parent/screens/login_page/password_recovery_screen.dart';
import 'package:go_parent/screens/signup_page/signup_screen.dart';
import 'package:go_parent/Screen/profile_screen.dart';
import 'package:go_parent/screens/home_page/home_screen.dart';
import 'package:go_parent/widgets/side_menu.dart';
import 'package:go_parent/screens/welcome_page/welcome_screen.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'screens/welcome_page/splash_screen.dart';
import 'screens/mission_page/mission_screen.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
 );

  WidgetsFlutterBinding.ensureInitialized();

  //Initialize Firebase with platform-specific options

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.black));

  

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GO PARENT',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: StreamBuilder<User?>(
      //   stream: FirebaseAuth.instance.authStateChanges(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return WelcomeScreen(); // Update this with the correct screen
      //     } else if (snapshot.hasData) {
      //       return WelcomeScreen(); // Update this with the correct screen
      //     } else {
      //       return WelcomeScreen();
      //     }
      //   },
      // ),
      initialRoute: 'login_screen',
      routes: {
        // GalleryScreen.id: (context) => GalleryScreen(),
        SplashScreen.id: (context) => SplashScreen(), // splash_screen
        WelcomeScreen.id: (context) => WelcomeScreen(), // welcome_screen
        
        Signup.id: (context) => Signup(), //id = "signup_screen""
       // home_screen
        PasswordRecovery.id: (context) => PasswordRecovery(), //password_recovery_screen
      },
    );
  }
}
