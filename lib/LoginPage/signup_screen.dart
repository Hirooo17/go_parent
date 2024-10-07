import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_parent/LoginPage/login_screen.dart';
import 'package:go_parent/Screen/home_screen.dart';
import 'package:go_parent/Widgets/RoundedButton.dart';
import 'package:go_parent/Widgets/responsive.dart';
import 'package:go_parent/Widgets/text_field.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});
  static String id = 'signup_screen';
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final double mobileSize = 700;
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signUpUser() async {
    setState(() {
      isLoading = true;
    });

    try {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        throw 'Please enter both email and password';
      }

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (userCredential.user != null) {
        // Optionally update the user's display name
        await userCredential.user!.updateDisplayName(nameController.text);

        Navigator.pushReplacementNamed(context, Homescreen.id);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          errorMessage = 'An account already exists for that email.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        default:
          errorMessage = 'An error occurred. Please try again.';
      }
      showErrorDialog(errorMessage);
    } catch (e) {
      showErrorDialog(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Row(
        children: [
          if (!Responsive.isMobile(context))
            Expanded(
                flex: Responsive.isTablet(context) ? 2 : 1,
                child: Container(
                    decoration: BoxDecoration(
                  color: Colors.blue, // Set the background color
                ))),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width > 600
                      ? MediaQuery.of(context).size.width * 0.4 // Desktop
                      : MediaQuery.of(context).size.width *
                          0.9, // 90% of the screen width
                  height: MediaQuery.of(context).size.height /
                      2.5, // A proportion of screen height
                  child: Image.asset(
                    'images/signup1.jpeg',
                    fit: BoxFit.cover, // Scale the image to cover the container
                  ),
                ),

                SizedBox(
                  width: mobileSize,
                  child: TextFieldInput(
                      icon: Icons.person,
                      textEditingController: nameController,
                      hintText: 'Enter your name',
                      textInputType: TextInputType.text),
                ),
                SizedBox(
                  width: mobileSize,
                  child: TextFieldInput(
                      icon: Icons.email,
                      textEditingController: emailController,
                      hintText: 'Enter your email',
                      textInputType: TextInputType.text),
                ),
                SizedBox(
                  width: mobileSize,
                  child: TextFieldInput(
                    icon: Icons.lock,
                    textEditingController: passwordController,
                    hintText: 'Enter your password',
                    textInputType: TextInputType.text,
                    isPass: true,
                  ),
                ),

                SizedBox(
                    width: mobileSize,
                    child: RoundedButton(
                        title: 'SIGN IN',
                        color: Colors.lightBlueAccent,
                        onPressed: () {
                          signUpUser();
                        })),
                SizedBox(height: height / 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?"),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                      child: Text(
                        "Log In",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    )
                  ],
                )

                //text field
              ],
            ),
          )
        ],
      )),
    );
  }
}
