// ignore_for_file: unused_import, duplicate_import

//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_parent/LoginPage/login_screen.dart';
import 'package:go_parent/LoginPage/SignupPage/signup_screen.dart';
import 'package:go_parent/Screen/home_screen.dart';
import 'package:go_parent/Screen/introduction_screen.dart';
import 'package:go_parent/Screen/profile_screen.dart';
import 'package:go_parent/Widgets/side_menu.dart';
import 'package:go_parent/intro%20screens/welcome_screen.dart';
//import 'Database/firebase_options.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'intro screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.black));
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  doWhenWindowReady(() {
    final win = appWindow;
    const desktopSize = Size(1200, 900); //change nyo nalang yung size, arbitrary values lang nilgaay ko
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      initialRoute: Signup.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        Homescreen.id: (context) => Homescreen(),
        LoginPage.id: (context) => LoginPage(),
        Signup.id: (context) => Signup(),
        Logout.id: (context) => Logout(),
      },
      // StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (context, snapshot){
      //  if (snapshot.hasData){
      //     return Homescreen();
      //  }else{
      //  return LoginPage();
      //  }
      //  }),
    );
  }
}
