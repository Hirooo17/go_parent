import 'package:flutter/material.dart';
import 'package:go_parent/Beta%20Testing%20Folder/note_screen.dart';
import 'package:go_parent/services/database/local/models/user_model.dart';
import 'package:go_parent/services/database/local/helpers/user_helper.dart';
import 'package:go_parent/services/database/local/sqlite.dart';

class BetaScreen extends StatefulWidget {
  @override
  _BetaScreenState createState() => _BetaScreenState();
}

class _BetaScreenState extends State<BetaScreen> {
  late UserHelper userHelper;
  List<UserModel> users = [];
  
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _scoreController = TextEditingController();
  
  final _formKey = GlobalKey<FormState>();
  int _selectedIndex = 0;
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _initializeHelper();
  }

  Future<void> _initializeHelper() async {
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

  Future<void> addUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = UserModel(
          username: _usernameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          totalScore: int.tryParse(_scoreController.text) ?? 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await userHelper.insertUser(user);
        fetchUsers();
        _clearForm();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User added successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding user: ${e.toString()}')),
        );
      }
    }
  }

  void _clearForm() {
    _usernameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _scoreController.clear();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      if (_currentUserId != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotesScreen(
              userId: _currentUserId!,
              username: users.firstWhere((user) => user.userId == _currentUserId).username,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a user first')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beta Testing Grounds'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _scoreController,
                    decoration: InputDecoration(
                      labelText: 'Score',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: addUser,
                    child: Text('Add User'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Registered Users:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  child: ListTile(
                    title: Text(user.username),
                    subtitle: Text(user.email),
                    trailing: Text('Score: ${user.totalScore}'),
                    selected: user.userId == _currentUserId,
                    onTap: () {
                      setState(() {
                        _currentUserId = user.userId;
                      });
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'Notes',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _scoreController.dispose();
    super.dispose();
  }
}