// ignore_for_file: unused_import, duplicate_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_parent/LoginPage/login_screen.dart';
import 'package:go_parent/LoginPage/signup_screen.dart';
import 'package:go_parent/Screen/home_screen.dart';
import 'package:go_parent/Screen/introduction_screen.dart';
import 'package:go_parent/Screen/profile_screen.dart';
import 'package:go_parent/Widgets/side_menu.dart';
import 'package:go_parent/intro%20screens/welcome_screen.dart';

import 'Database/firebase_options.dart';


void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Color(0xFFB2DFDB)),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show splash screen while waiting for authentication
            return WelcomeScreen();
          } else if (snapshot.hasData) {
            // User is logged in, show the home screen
            return LoginPage();
          } else {
            // User is not logged in, show the login page
            return WelcomeScreen(); // You can change this to LoginPage if you prefer
          }
        },
      ),
      // Uncomment if you want to use named routes
      /*
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        Homescreen.id: (context) => Homescreen(),
        LoginPage.id: (context) => LoginPage(),
        Signup.id: (context) => Signup(),
      },
      */
    );
  }
}
