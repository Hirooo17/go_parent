// ignore_for_file: unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_parent/LoginPage/login_screen.dart';
import 'package:go_parent/LoginPage/signup_screen.dart';
import 'package:go_parent/Screen/home_screen.dart';
import 'package:go_parent/Screen/profile_screen.dart';
import 'package:go_parent/Widgets/side_menu.dart';

import 'firebase_options.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.lightBlue));
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
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: Signup.id,
        routes: {
          Homescreen.id: (context) => Homescreen(),
          LoginPage.id: (context) => LoginPage(),
          Signup.id: (context) => Signup(),
          Logout.id: (context) => Logout(),
        }
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
