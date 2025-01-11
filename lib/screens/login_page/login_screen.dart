// ignore_for_file: sort_child_properties_last, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_parent/Screen/dashboard.dart';
import 'package:go_parent/screens/home_page/home_screen.dart';
import 'package:go_parent/services/database/local/helpers/user_helper.dart';
import 'package:go_parent/services/database/local/sqlite.dart';
import 'package:go_parent/screens/login_page/login_brain.dart';
import 'package:go_parent/utilities/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' show Platform;

class LoginPage1 extends StatefulWidget {
  const LoginPage1({super.key});
  static String id = 'login_screen';

  @override
  State<LoginPage1> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage1> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailRecoveryController = TextEditingController();
  late LoginBrain loginBrain;
  bool isLoading = false;
  bool? cbValue = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailRecoveryController.dispose();
    super.dispose();
  }

  @override
void initState() {
  super.initState();
  WidgetsFlutterBinding.ensureInitialized();
  _initializeLoginBrain();
}

Future<void> _initializeLoginBrain() async {
  // Only initialize FFI on desktop platforms
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  final dbService = DatabaseService.instance;
  final db = await dbService.database;
  final userHelper = UserHelper(db);
  loginBrain = LoginBrain(userHelper);
}
  void handleLogin(BuildContext context) async {
    setState(() => isLoading = true);
    try {
      bool loginSuccess = await loginBrain.loginUser(
        emailController.text, 
        passwordController.text
      );

      if (loginSuccess) {
        final db = await DatabaseService.instance.database;
        final userHelper = UserHelper(db);
        final user = await userHelper.getUserByEmail(emailController.text);

        if (user != null && user.userId != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Homescreen(
                username: user.username,
                userId: user.userId!,
              ),
            ),
          );
        } else {
          _showAlert(
            context, 
            "Error", 
            "Failed to retrieve user details. Please try again."
          );
        }
      } else {
        _showAlert(
          context, 
          "Login Failed", 
          "Invalid username or password. Please try again."
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showAlert(BuildContext context, String title, String message) {
    Alert(
      context: context,
      type: AlertType.error,
      title: title,
      desc: message,
      buttons: [
        DialogButton(
          child: Text("OK", style: TextStyle(color: Colors.white, fontSize: 20)),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

  void _showRecoveryDialog(BuildContext context) {
    Alert(
      context: context,
      title: "Recover Your Account",
      content: Column(
        children: <Widget>[
          Text(
            "Please enter your email. We will send you a password reset link.",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          TextField(
            controller: emailRecoveryController,
            decoration: InputDecoration(
              icon: Icon(Icons.email),
              labelText: 'Email',
              border: OutlineInputBorder(),
              filled: true,
            ),
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
      buttons: [
        DialogButton(
          onPressed: () {
            loginBrain.recoverUserAccount(emailRecoveryController.text);
            Navigator.pop(context);
          },
          child: Text(
            "Send Reset Link",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 600;
    final contentWidth = isDesktop ? size.width * 0.4 : size.width * 0.85;
    final imageHeight = isDesktop ? size.height * 0.4 : size.height * 0.3;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(maxWidth: 1200),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo and Image Section
                Container(
                  width: contentWidth,
                  height: imageHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/login.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 40),

                // Login Form Section
                Container(
                  width: contentWidth,
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      SizedBox(height: 30),
                      
                      // Email Field
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email, color: Colors.teal),
                          hintText: 'Enter your email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                      SizedBox(height: 20),
                      
                      // Password Field
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock, color: Colors.teal),
                          hintText: 'Enter your password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                      SizedBox(height: 20),

                      // Remember Me Checkbox
                      Row(
                        children: [
                          Checkbox(
                            value: cbValue,
                            onChanged: (value) => setState(() => cbValue = value),
                            activeColor: Colors.teal,
                          ),
                          Text("Remember Me", style: kh3LabelTextStyle),
                        ],
                      ),
                      SizedBox(height: 30),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : () => handleLogin(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  "LOG IN",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),

                // Footer Section
                Container(
                  width: contentWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => _showRecoveryDialog(context),
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.teal),
                        ),
                      ),
                      Row(
                        children: [
                          Text("Don't have an account? "),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'signup_screen');
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}