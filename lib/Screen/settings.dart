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
        title: const Text("Settings"),
        backgroundColor: Colors.lightGreen[600], // Light green app bar
      ),
      body: const CardSettings(),
      backgroundColor: Colors.lightGreen[50], // Soft green background
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
        color: Colors.lightGreen[100], // Light green card background
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SettingsTile(
              icon: Icons.person,
              title: 'Change Username',
              subtitle: 'Press continue to update your username',
            ),
            const SettingsTile(
              icon: Icons.lock,
              title: 'Change Password',
              subtitle: 'Ensure a strong password',
            ),
            const SettingsTile(
              icon: Icons.notifications,
              title: 'Notification Settings',
              subtitle: 'Adjust your notification preferences',
            ),
            const SettingsTile(
              icon: Icons.privacy_tip,
              title: 'Privacy Settings',
              subtitle: 'Manage your privacy settings',
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.lightGreen[800]),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {},
              child: const Text("Continue"),
              style: TextButton.styleFrom(
                foregroundColor: Colors.lightGreen[800], // Light green button text
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        const Divider(height: 1), // Divider between tiles
      ],
    );
  }
}
