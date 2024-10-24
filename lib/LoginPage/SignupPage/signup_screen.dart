//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_parent/LoginPage/SignupPage/calculate_age.dart';
import 'package:go_parent/LoginPage/SignupPage/verification_countdown.dart';
import 'package:go_parent/LoginPage/login_screen.dart';
import 'package:go_parent/Widgets/text_field.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:go_parent/Widgets/floating_label_textfield.dart';
import 'package:go_parent/LoginPage/SignupPage/signup_brain.dart';

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
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController userContactNumController =
      TextEditingController();
  final TextEditingController userGenderController = TextEditingController();
  final TextEditingController babyNameController = TextEditingController();
  final TextEditingController babyDateBirthController = TextEditingController();
  final TextEditingController babyGenderController = TextEditingController();
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  final double mobileSize = 700;
  bool isLoading = false;

  final PageController _pageController = PageController();
  int currentSlide = 0;

  SignupBrain signupBrain = SignupBrain();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _pageController.dispose();
    super.dispose();
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
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void nextForm() {
    if (currentSlide < 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void formOneHandler() {
    if (signupBrain.emailChecker(emailController, context) &&
        signupBrain.passwordChecker(
            passwordController, confirmPasswordController, context)) {
      nextForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 600,
              minWidth: 400,
            ),
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
                                  height:
                                      MediaQuery.of(context).size.height / 2.5,
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
                                    onPressed: formOneHandler,
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
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                         Text(
                                          "Now Let's Make you a",
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'CodeNewRoman',
                                          ),
                                        ),
                                        Text(
                                          "GoParent Member.",
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'CodeNewRoman',
                                          ),
                                        ),
                                      SizedBox(height: 60),
                                  
                                        
                                         Align(
                                          alignment: Alignment.centerLeft,
                                           child: Text(
                                              "We've sent a code to",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                         ),
                                       
                                          Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                emailController.text,
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
                                                    color: Colors.black45,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                      SizedBox(height: 20),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Center(
                                        child: Text(
                                          "Verification Code",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            fontFamily: 'CodeNewRoman',
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          for (int i = 0; i < 5; i++) ...[
                                            Expanded(
                                              child: TextFormField(
                                                onSaved: (pin) {},
                                                onChanged: (value) {
                                                  if (value.length == 1) {
                                                    FocusScope.of(context)
                                                        .nextFocus();
                                                  }
                                                },
                                                textAlign: TextAlign.center,
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(
                                                      1),
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                ],
                                              ),
                                            ),
                                            if (i < 4) SizedBox(width: 8),
                                          ],
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Container
                                        (
                                          height: 20,
                                          width: 60,
                                          child: VerificationCountdown(),),
                                      ),
                                      SizedBox(height: 60),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Center(
                                        child: Text(
                                          "Your Information",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            fontFamily: 'CodeNewRoman',
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: FloatingLabelTextField(
                                              hintText: "Name",
                                              controller: userNameController,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            flex: 2,
                                            child: FloatingLabelTextField(
                                              hintText: "Gender",
                                              controller: userGenderController,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      FloatingLabelTextField(
                                        hintText: "Contact Number",
                                        controller: userContactNumController,
                                        keyboardType: TextInputType.number,
                                      ),
                                      SizedBox(height: 60),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Center(
                                        child: Text(
                                          "Baby's Information",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            fontFamily: 'CodeNewRoman',
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: FloatingLabelTextField(
                                              hintText: "Name",
                                              controller: babyNameController,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            flex: 2,
                                            child: FloatingLabelTextField(
                                              hintText: "Gender",
                                              controller: babyGenderController,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      CalculateAge(),
                                    ],
                                  ),
                                  SizedBox(height: 60),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.teal,
                                      minimumSize: Size(1000, 55),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(9),
                                      ),
                                    ),
                                    onPressed: () {
                                      //implement
                                    },
                                    child: Text('SIGN IN', style: TextStyle(fontSize: 18),),
                                  ),
                                  SizedBox(height: 90),

                                Row(
                                  
                                  children: [ 

                                    SizedBox(width: 60,),
                                    Expanded(child: Text("We are dedicated to protecting your privacy.", style:TextStyle(fontSize: 14))),

                                Expanded(child: Text('The data you provide will be used exclusively to enable the app to perform its intended functions and will not be shared or used for any other purpose.', style: TextStyle(fontSize:14),))
                                 
                                 
                                  ],
                                ),
                               
                                ],

                              ),
                            ),
                          ),
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
                if (currentSlide == 0)
                  Padding(
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
                              color: Colors.teal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 46),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
