import 'package:flutter/material.dart';
import 'package:go_parent/LoginPage/SignupPage/signup_screen.dart';
import 'package:go_parent/Screen/home_screen.dart';
import 'package:go_parent/Widgets/RoundedButton.dart';
import 'package:go_parent/Widgets/snackbar.dart';
import 'package:go_parent/Widgets/text_field.dart';
import 'package:go_parent/authentication/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String id = 'login_screen';

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

// email and password auth part
  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    // login user using authmethod
    String res = await AuthMethod().loginUser(
        email: emailController.text, password: passwordController.text);

    if (res == "success") {
      setState(() {
        isLoading = false;
      });
      // navigate to the home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Homescreen(
            username: usernameController.text,
          ),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      // show error
      showSnackBar(context, res);
    }
  }

  void byPass() {
    // Navigate without setting state
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Homescreen(
                username: usernameController.text,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true, // Let the screen adjust when keyboard shows
      body: SafeArea(
        child: SingleChildScrollView(
          // Ensure it scrolls when the keyboard shows
          child: Padding(
            padding: EdgeInsets.only(bottom: keyboardHeight),
            child: Column(
              
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: height / 2.7,
                  child: Image.asset('assets/images/login.jpg'),
                ),
                TextFieldInput(
                    icon: Icons.person,
                    textEditingController: usernameController,
                    hintText: 'Enter your Username',
                    textInputType: TextInputType.text),
                TextFieldInput(
                    icon: Icons.person,
                    textEditingController: emailController,
                    hintText: 'Enter your email',
                    textInputType: TextInputType.text),
                TextFieldInput(
                  icon: Icons.lock,
                  textEditingController: passwordController,
                  hintText: 'Enter your password',
                  textInputType: TextInputType.text,
                  isPass: true,
                ),

                // Forgot Password Link
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Forgot Password",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue),
                    ),
                  ),
                ),

                // LOGIN Button
                RoundedButton(
                    title: "LOGIN",
                    color: Colors.lightBlueAccent,
                    onPressed: byPass),

                SizedBox(height: height / 15), // Add space before sign up

                // Sign Up option
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't Have an account?"),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Signup()));
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    )
                  ], 
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
