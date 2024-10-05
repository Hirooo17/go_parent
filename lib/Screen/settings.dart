import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Settings"),
      ),
      body: CardSettings(),
    );
  }
}

class CardSettings extends StatelessWidget {
  const CardSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Card(
        
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(//username
              leading: Icon(Icons.settings),
              title: Text('Change Username'),
              subtitle: Text('Press continue'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () {}, child: Text("Continue")),
                const SizedBox(width: 8),
              ],
            ),
            const ListTile(//for password
              leading: Icon(Icons.settings),
              title: Text('Change Password'),
              subtitle: Text('Ensure A Strong Password'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () {}, child: Text("Continue")),
                const SizedBox(width: 8),
              ],
            ),
            const ListTile(//for password
              leading: Icon(Icons.settings),
              title: Text('Change Password'),
              subtitle: Text('Ensure A Strong Password'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () {}, child: Text("Continue")),
                const SizedBox(width: 8),
              ],
            ),
            const ListTile(//for password
              leading: Icon(Icons.settings),
              title: Text('Change Password'),
              subtitle: Text('Ensure A Strong Password'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () {}, child: Text("Continue")),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
