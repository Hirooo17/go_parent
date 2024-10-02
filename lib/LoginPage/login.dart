// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:go_parent/LoginPage/signup.dart';
import 'package:go_parent/Screen/HomeScree.dart';
import 'package:go_parent/Widgets/text_field.dart';
import 'package:go_parent/Widgets/text_field.dart';
import 'package:go_parent/Widgets/button.dart';
import 'package:go_parent/authentication/auth.dart';
import 'package:go_parent/Widgets/snackbar.dart';
import 'package:go_parent/Widgets/responsive.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  final double mobileSize = 700;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

// email and passowrd auth part
  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    // signup user using our authmethod
    String res = await AuthMethod().loginUser(
        email: emailController.text, password: passwordController.text);

    if (res == "success") {
      setState(() {
        isLoading = false;
      });
      //navigate to the home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Homescreen(),
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
    // You don't need setState here, as Navigator.push does not require it
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Homescreen()),
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
          if(!Responsive.isMobile(context))
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
                  width: double.infinity,
                  height: height / 2.7,
                  child: Image.asset('images/login.jpg'),
                ),

                SizedBox(
                  width: mobileSize,
                  child: TextFieldInput(
                      icon: Icons.person,
                      textEditingController: emailController,
                      hintText: 'Enter your email',
                      textInputType: TextInputType.text),
                ),

                SizedBox(
                  width: mobileSize,
                  child: TextFieldInput(
                    icon: Icons.lock,
                    textEditingController: passwordController,
                    hintText: 'Enter your passord',
                    textInputType: TextInputType.text,
                    isPass: true,
                  ),
                ),

                //  we call our forgot password below the login in button
                SizedBox(
                  width: mobileSize,
                  child: Padding(
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
                ),

                // bypass added for debugging purposes
                SizedBox(child: MyButtons(onTap: byPass, text: "login"), width: mobileSize,),
                SizedBox(height: height / 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Dont Have an account?"),
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

                //text field
              ],
            ),
          ),
        ],
      )),
    );
  }
}// login pageu i
