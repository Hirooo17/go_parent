import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_parent/LoginPage/login_screen.dart';
import 'package:go_parent/Screen/home_screen.dart';
import 'package:go_parent/Widgets/text_field.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});
  static String id = 'signup_screen';

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final double mobileSize = 700;
  bool isLoading = false;

  final PageController _pageController = PageController();
  int currentSlide = 0;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void signUpUser() async {
    final currentContext = context;
    setState(() {
      isLoading = true;
    });

    try {
      if (emailController.text.isEmpty ||
          passwordController.text.isEmpty ||
          confirmPasswordController.text.isEmpty) {
        throw 'Please fill all fields';
      }

      if (passwordController.text != confirmPasswordController.text) {
        throw 'Passwords do not match';
      }

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (userCredential.user != null) {
        Navigator.pushReplacementNamed(currentContext, Homescreen.id);
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

  void previousForm() {
    if (currentSlide > 0) {
      _pageController.previousPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  void nextForm() {
    if (currentSlide < 1) {
      _pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  PageView(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        currentSlide = index;
                      });
                    },
                    children: [
                      // Form 1
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width > 600
                                  ? MediaQuery.of(context).size.width * 0.4
                                  : MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.height / 2.5,
                              child: Image.asset(
                                'assets/images/signup1.jpeg',
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              width: mobileSize,
                              child: TextFieldInput(
                                icon: Icons.email,
                                textEditingController: emailController,
                                hintText: 'Enter your email',
                                textInputType: TextInputType.emailAddress,
                              ),
                            ),
                            SizedBox(height: 10),
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
                            SizedBox(height: 10),
                            SizedBox(
                              width: mobileSize,
                              child: TextFieldInput(
                                icon: Icons.lock,
                                textEditingController:
                                    confirmPasswordController,
                                hintText: 'Confirm your password',
                                textInputType: TextInputType.text,
                                isPass: true,
                              ),
                            ),
                            SizedBox(height: 20),
                            Material(
                              elevation: 5.0,
                              color: Color(0xFF009688),
                              borderRadius: BorderRadius.circular(30.0),
                              child: MaterialButton(
                                onPressed: nextForm,
                                minWidth: mobileSize * .4,
                                height: 50.0,
                                child: Text(
                                  "Continue",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Form 2
                      Padding(
                        padding: const EdgeInsets.all(42),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Now Let's Make you a \nGoParent Member.",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'CodeNewRoman',
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "We've sent a code to",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    Row(children: [
                                      Text(
                                        "changeTo@UserEmailVariable.",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'CodeNewRoman',
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: previousForm,
                                        child: Text(
                                          "Edit",
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              fontSize: 16,
                                              fontFamily: 'CodeNewRoman',
                                              color: Colors.black45),
                                        ),
                                      )
                                    ]),
                                  ]),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text(
                                    "Verification Code",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      fontFamily: 'CodeNewRoman',
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: TextFormField(
                                        onSaved: (pin1) {},
                                        onChanged: (value) {
                                          if (value.length == 1) {
                                            FocusScope.of(context).nextFocus();
                                          }
                                        },
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(1),
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                      )),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                          child: TextFormField(
                                        onSaved: (pin2) {},
                                        onChanged: (value) {
                                          if (value.length == 1) {
                                            FocusScope.of(context).nextFocus();
                                          }
                                        },
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(1),
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                      )),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                          child: TextFormField(
                                        onSaved: (pin3) {},
                                        onChanged: (value) {
                                          if (value.length == 1) {
                                            FocusScope.of(context).nextFocus();
                                          }
                                        },
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(1),
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                      )),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                          child: TextFormField(
                                        onSaved: (pin4) {},
                                        onChanged: (value) {
                                          if (value.length == 1) {
                                            FocusScope.of(context).nextFocus();
                                          }
                                        },
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(1),
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                      )),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                          child: TextFormField(
                                        onSaved: (pin5) {},
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(1),
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                      )),
                                      SizedBox(
                                        width: 8,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 100,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Positioned(
                    bottom: height / 150,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        SmoothPageIndicator(
                          controller: _pageController,
                          count: 2,
                          effect: ExpandingDotsEffect(
                            activeDotColor: Colors.teal,
                            dotColor: Colors.grey,
                            dotHeight: 10,
                            dotWidth: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height / 15),
            currentSlide == 0
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?"),
                        SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, LoginPage.id);
                          },
                          child: Text(
                            "Log In",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.teal),
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(
                    height: 46,
                  )
          ],
        ),
      ),
    );
  }
}
