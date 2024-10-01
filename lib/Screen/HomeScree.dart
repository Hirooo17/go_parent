import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_parent/LoginPage/login.dart';
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
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyButtons(
              onTap: () async {
                // Logout using Firebase auth services
                await _authMethod.signOut();

                // Navigate to the login page after logout
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              text: "LOGOUT",
            ),
          ],
        ),
      ),
    );
  }
}
