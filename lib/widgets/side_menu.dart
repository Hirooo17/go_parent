import 'package:flutter/material.dart';
import 'package:go_parent/screens/login_page/login_screen.dart';
import 'package:go_parent/Screen/settings.dart';
import 'package:go_parent/widgets/button.dart';
import 'package:go_parent/services/authentication/auth.dart';

class SideMenu extends StatelessWidget {
  AuthMethod get _authMethod => AuthMethod();
  final String username;

  const SideMenu({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(username),
              accountEmail: Text("I love Cannons"),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.asset('assets/images/tristana.png'),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                image: DecorationImage(
                  image: AssetImage('assets/images/tristanaa.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Settings()),
                );
              },
            ),
            Spacer(),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.notification_add_rounded),
              title: Text("Notifications"),
              onTap: () {},
            ),
            SizedBox(height:300),
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
