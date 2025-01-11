import 'package:flutter/material.dart';

import 'package:go_parent/Widgets/RoundedButton.dart';
import 'package:go_parent/Widgets/snackbar.dart';
import 'package:go_parent/Widgets/text_field.dart';
import 'package:go_parent/screens/home_page/home_screen.dart';
import 'package:go_parent/screens/signup_page/signup_screen.dart';
import 'package:go_parent/services/authentication/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String id = 'login_screen1';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
  }

  

  void byPass() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Homescreen(
                username: usernameController.text,
                userId: 1,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 600;
    
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 800, // Maximum width for larger screens
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 20 : 40,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Responsive image container
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: isSmallScreen ? 200 : 300,
                        maxWidth: isSmallScreen ? 300 : 400,
                      ),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.asset(
                          'assets/images/login.jpg',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    
                    // Form fields with responsive width
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: 400, // Maximum width for input fields
                      ),
                      child: Column(
                        children: [
                          TextFieldInput(
                            icon: Icons.person,
                            textEditingController: usernameController,
                            hintText: 'Enter your Username',
                            textInputType: TextInputType.text,
                          ),
                          SizedBox(height: 16),
                          TextFieldInput(
                            icon: Icons.person,
                            textEditingController: emailController,
                            hintText: 'Enter your email',
                            textInputType: TextInputType.text,
                          ),
                          SizedBox(height: 16),
                          TextFieldInput(
                            icon: Icons.lock,
                            textEditingController: passwordController,
                            hintText: 'Enter your password',
                            textInputType: TextInputType.text,
                            isPass: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),

                    // Forgot Password
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(maxWidth: 400),
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Forgot Password",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),

                    // Login Button
                    Container(
                      constraints: BoxConstraints(maxWidth: 400),
                      child: RoundedButton(
                        title: "LOGIN",
                        color: Colors.lightBlueAccent,
                        onPressed: byPass,
                      ),
                    ),
                    SizedBox(height: 24),

                    // Sign Up Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't Have an account?"),
                        SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Signup()),
                            );
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}