// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_parent/LoginPage/login_screen.dart';
import 'package:go_parent/Widgets/button.dart';
import 'package:go_parent/authentication/auth.dart';

class Logout extends StatefulWidget {
  const Logout({super.key});
  static String id = 'profile_screen';

  @override
  State<Logout> createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  final AuthMethod _authMethod = AuthMethod(); // Instantiate AuthMethod
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'SCREEN UNDER MAINTENANCE, THIS IS A PROFILE SCREEN',
                  style:
                      TextStyle(fontSize: 24), // Customize your text style here
                ),
              ),
            ),
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
             SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
