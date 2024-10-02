import 'package:flutter/material.dart';
import 'package:go_parent/LoginPage/login.dart';
import 'package:go_parent/Screen/HomeScree.dart';
import 'package:go_parent/Widgets/text_field.dart';
import 'package:go_parent/Widgets/text_field.dart';
import 'package:go_parent/Widgets/button.dart';
import 'package:go_parent/Widgets/snackbar.dart';
import 'package:go_parent/authentication/auth.dart';
import 'package:go_parent/Widgets/responsive.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  final double mobileSize = 700;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }

  void signupUser() async {
    // set is loading to true.
    setState(() {
      isLoading = true;
    });
    // signup user using our authmethod
    String res = await AuthMethod().signupUser(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text);
    // if string return is success, user has been creaded and navigate to next screen other witse show error.
    if (res == "success") {
      setState(() {
        isLoading = false;
      });
      //navigate to the next screen
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
                      : MediaQuery.of(context).size.width * 0.9, // 90% of the screen width
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
                    hintText: 'Enter your passord',
                    textInputType: TextInputType.text,
                    isPass: true,
                  ),
                ),

                SizedBox(
                  width: mobileSize,
                  child: MyButtons(onTap: signupUser, text: "Sign Up"),
                ),
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
