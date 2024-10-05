import 'package:flutter/material.dart';
import 'package:go_parent/Screen/settings.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("Tristana"),
              accountEmail: Text("I love Cannons"),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.asset('images/tristana.png'),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                image: DecorationImage(
                  image: AssetImage('images/tristanaa.jpg'),
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
          ],
        ),
      ),
    );
  }
}
