// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_parent/LoginPage/login_screen.dart';
import 'package:go_parent/Screen/childcare.dart';
import 'package:go_parent/Screen/view%20profile/viewprofile.dart';
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
    // Get the screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'SCREEN UNDER MAINTENANCE, THIS IS A PROFILE SCREEN',
              style: TextStyle(fontSize: 24), 
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            // Dashboard Cards
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // Number of columns
                padding: EdgeInsets.all(16.0),
                childAspectRatio: (screenWidth /
                    (screenHeight * 0.5)), // Dynamic aspect ratio
                children: [
                  _buildCard('View Profile', Colors.blue, screenWidth, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => profileviewer()));
                  }),
                  _buildCard('Child Care', Colors.green, screenWidth, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Childcare()));
                  }),
                  _buildCard('Card 3', Colors.orange, screenWidth, () {}),
                  _buildCard('Card 4', Colors.red, screenWidth, () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
      String title, Color color, double screenWidth, void Function() onTap) {
    return GestureDetector(
      onTap: onTap, // Define the function to be called on tap
      child: Card(
        color: color,
        margin: EdgeInsets.all(10.0),
        elevation: 5,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
