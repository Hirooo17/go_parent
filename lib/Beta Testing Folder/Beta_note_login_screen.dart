import 'package:flutter/material.dart';
import 'package:go_parent/Beta%20Testing%20Folder/note_screen.dart';
import 'package:go_parent/services/database/local/models/user_model.dart';
import 'package:go_parent/services/database/local/helpers/user_helper.dart';
import 'package:go_parent/services/database/local/sqlite.dart';

class BetaScreenNote extends StatefulWidget {
  @override
  _BetaScreenNoteState createState() => _BetaScreenNoteState();
}

class _BetaScreenNoteState extends State<BetaScreenNote> {
  late UserHelper userHelper;
  List<UserModel> users = [];
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    final db = await DatabaseService.instance.database;
    userHelper = UserHelper(db);
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final userList = await userHelper.getAllUsers();
    setState(() {
      users = userList;
    });
  }

  Future<void> loginUser() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    final user = users.firstWhere(
      (user) => user.username == username && user.password == password,
      
    );

    if (user == null) {
      // Show error message for invalid credentials
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid username or password.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Navigate to NotesScreen with user details
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotesScreen(
          userId: user.userId!,
          username: user.username,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: loginUser,
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
