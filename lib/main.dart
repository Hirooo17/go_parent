import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth import
import 'package:firebase_core/firebase_core.dart'; // Firebase Core import
import 'package:go_parent/LoginPage/login_screen.dart';
import 'package:go_parent/LoginPage/SignupPage/signup_screen.dart';
import 'package:go_parent/Screen/home_screen.dart';
import 'package:go_parent/Screen/introduction_screen.dart';
import 'package:go_parent/Screen/profile_screen.dart';
import 'package:go_parent/Widgets/side_menu.dart';
import 'package:go_parent/intro%20screens/welcome_screen.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'intro screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.black));
  
  // Initialize Firebase
  await Firebase.initializeApp();

  doWhenWindowReady(() {
    final win = appWindow;
    const desktopSize = Size(1200, 900); // Set the desired window size
    win.alignment = Alignment.center;
    win.size = desktopSize;
    win.minSize = desktopSize;
    win.maxSize = desktopSize;
    win.show();
  });

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
      initialRoute: Signup.id,  // Set the initial route
      routes: {
        '/': (context) => StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SplashScreen();  // Show splash screen while waiting for authentication
            } else if (snapshot.hasData) {
              // User is logged in, navigate to Home Screen
              return Homescreen(username: snapshot.data?.email ?? 'User');
            } else {
              // User is not logged in, navigate to Welcome Screen
              return WelcomeScreen(); 
            }
          },
        ),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        Homescreen.id: (context) => Homescreen(username: 'Guest'),
        LoginPage.id: (context) => const LoginPage(),
        Signup.id: (context) => const Signup(),
      },
    );
  }
}
