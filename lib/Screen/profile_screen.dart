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
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
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
      ),
    );
  }
}
