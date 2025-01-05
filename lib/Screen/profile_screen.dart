import 'package:flutter/material.dart';
import 'package:go_parent/Beta%20Testing%20Folder/Beta.dart';
import 'package:go_parent/Beta%20Testing%20Folder/Beta_note_login_screen.dart';
import 'package:go_parent/Beta%20Testing%20Folder/note_screen.dart';
import 'package:go_parent/screens/login_page/login_screen.dart';
import 'package:go_parent/Screen/childcare.dart';
import 'package:go_parent/Screen/view%20profile/viewprofile.dart';
import 'package:go_parent/widgets/button.dart';
import 'package:go_parent/services/authentication/auth.dart';
import 'package:go_parent/services/database/local/models/user_model.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../services/database/local/helpers/user_helper.dart';

class Logout extends StatefulWidget {
 
  static String id = 'profile_screen';
  

  

  @override
  State<Logout> createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  // Instantiate AuthMethod
  late UserHelper _userHelper;
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  // Fetch the logged-in user from the database
  void _loadUser() async {
    final db = await openDatabase('goparent.db'); // Update with the correct path
    _userHelper = UserHelper(db);
    
    // Assuming the user is logged in and we have their userId stored in shared preferences or another method
    final userId = 1; // Replace with the actual logged-in user's ID
    final user = await _userHelper.getUserById(userId);

    setState(() {
      _user = user;
    });
  }
  // final AuthMethod _authMethod = AuthMethod(); // Instantiate AuthMethod

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()), // Wait until user is loaded
      );
    }

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
                childAspectRatio: (screenWidth / (screenHeight * 0.5)), // Dynamic aspect ratio
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
                  _buildCard('Beta Testing Grounds', Colors.orange, screenWidth, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BetaScreen()));
                  }),
                  _buildCard('Beta Note Login', Colors.red, screenWidth, () {
                    // Ensure to pass the correct userId and username
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BetaScreen(),
                      ),
                    );
                  }),
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
