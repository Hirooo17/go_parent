import 'package:flutter/material.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text("home"),
      ),
      drawer: Drawerr(),
    );
  }

  Drawer Drawerr() {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text("roar"),
            onTap: () {},
          )
        ],
      ),
    );
  }
}

class MyDrawer {
  Drawer Drawerr(String title) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text(title),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.name,
    required this.profession,
  });

  final String name, profession;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white24,
        child: Icon(
          Icons.person,
          color: Colors.white,
        ),
      ),

      // name
      title: Text(
        name,
        style: TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        profession,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
