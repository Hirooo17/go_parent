import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_parent/services/database/local/helpers/baby_helper.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:email_otp/email_otp.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:go_parent/screens/signup_page/signup_brain.dart';
import 'package:go_parent/widgets/text_field.dart';
import 'package:go_parent/widgets/floating_label_textfield.dart';
import 'package:go_parent/services/database/local/sqlite.dart';
import 'package:go_parent/services/database/local/helpers/user_helper.dart';

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
  final TextEditingController babyNameController = TextEditingController();
  final TextEditingController babyGenderController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  late Timer _timer;
  int _secondsLeft = 59;
  DateTime? _selectedDate;

  final double mobileSize = 700;
  bool isLoading = false;
  List<String> otpValues = List.filled(6, '');
  List<TextEditingController> otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  String get compiledOTP => otpControllers.map((c) => c.text).join();
  final PageController _pageController = PageController();
  int currentSlide = 0;

  late SignupBrain signupBrain;

  @override
  void initState() {
    super.initState();

    startTimer();
    WidgetsFlutterBinding.ensureInitialized();
    _initializeSignupBrain();
  }

  Future<void> _initializeSignupBrain() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    final dbService = DatabaseService.instance;
    final db = await dbService.database;
    final userHelper = UserHelper(db);
    final babyHelper = BabyHelper(db);
    signupBrain = SignupBrain(userHelper, babyHelper);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _pageController.dispose();
    dobController.dispose();
    _timer.cancel();

    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void startTimer() {
    setState(() {
      _secondsLeft = 59;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsLeft > 0) {
          _secondsLeft--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  Future<bool> verifyOTP() async {
    String enteredOTP = otpValues.join();
    bool isValid = await EmailOTP.verifyOTP(
      otp: enteredOTP,
    );
    if (!isValid) {
      Alert(
        context: context,
        type: AlertType.error,
        title: "Invalid OTP",
        desc: "Please enter the correct OTP code.",
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    }
    return isValid;
  }

  Future<void> _registerUser() async {
    bool isOTPValid = await verifyOTP();
    if (isOTPValid) {
      final isSignupSuccessful = await signupBrain.signupUser(
        usernameController: userNameController,
        emailController: emailController,
        passwordController: passwordController,
        babyNameController: babyNameController,
        babyDobController: dobController,
        babyGenderController: babyGenderController,
        context: context,
      );
      if (isSignupSuccessful) {
        Alert(
          context: context,
          type: AlertType.success,
          title: 'Registration Successful!',
          desc: 'You have registered successfully, redirecting to login page...',
          buttons: [
            DialogButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'login_screen');
              },
            ),
          ],
        ).show();
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 7, now.month, now.day);
    final lastDate = DateTime(now.year + 100, now.month, now.day);
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  void formOneHandler() async {
    if (!signupBrain.emailChecker(emailController, context) ||
        passwordController.text.isEmpty ||
        !signupBrain.passwordChecker(
            passwordController, confirmPasswordController, context)) {
      return;
    }

    EmailOTP.config(
        appEmail: "teamgoparent@goparent.com",
        appName: "GoParent",
        otpLength: 6,
        emailTheme: EmailTheme.v6,
        otpType: OTPType.numeric);

    try {
      bool otpSent = await EmailOTP.sendOTP(email: emailController.text);

      if (otpSent) {
        Alert(
          context: context,
          type: AlertType.success,
          title: "Email OTP Sent!",
          desc: "OTP has been sent to your email.",
          buttons: [
            DialogButton(
              onPressed: () {
                Navigator.pop(context);
                nextForm();
              },
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ],
        ).show();
      } else {
        Alert(
          context: context,
          type: AlertType.error,
          title: "Error",
          desc: "Failed to send OTP. Please try again.",
          buttons: [
            DialogButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ],
        ).show();
      }
    } catch (e) {
      Alert(
        context: context,
        type: AlertType.error,
        title: "Error",
        desc: "An unexpected error occurred. Please try again.",
        buttons: [
          DialogButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ],
      ).show();
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

  void _sendNewVerificationCode() async {
    EmailOTP.config(
        appEmail: "teamgoparent@goparent.com",
        appName: "GoParent",
        otpLength: 6,
        otpType: OTPType.numeric);

    try {
      bool otpSent = await EmailOTP.sendOTP(email: emailController.text);

      if (otpSent) {
        Alert(
          context: context,
          type: AlertType.success,
          title: "Email OTP Sent!",
          desc: "OTP has been sent to your email.",
          buttons: [
            DialogButton(
              onPressed: () {
                Navigator.pop(context);
                nextForm();
              },
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ],
        ).show();
      } else {
        Alert(
          context: context,
          type: AlertType.error,
          title: "Error",
          desc: "Failed to send OTP. Please try again.",
          buttons: [
            DialogButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ],
        ).show();
      }
    } catch (e) {
      Alert(
        context: context,
        type: AlertType.error,
        title: "Error",
        desc: "An unexpected error occurred. Please try again.",
        buttons: [
          DialogButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ],
      ).show();
    }
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
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
                                          for (int i = 0; i < 6; i++) ...[
                                            Expanded(
                                              child: TextFormField(
                                                onSaved: (pin) {},
                                                onChanged: (value) {
                                                  if (value.length == 1) {
                                                    setState(() {
                                                      otpValues[i] = value;
                                                    });
                                                    if (i < 5) {
                                                      FocusScope.of(context)
                                                          .nextFocus();
                                                    }
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
                                            if (i < 5) SizedBox(width: 8),
                                          ],
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: SizedBox(
                                          height: 20,
                                          width: 100,
                                          child: Center(
                                            child: _secondsLeft > 0
                                                ? Text(
                                                    '$_secondsLeft seconds left',
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  )
                                                : GestureDetector(
                                                    onTap: () {
                                                      _sendNewVerificationCode();
                                                      startTimer();
                                                    },
                                                    child: Text(
                                                      'Resend',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black45,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                        ),
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
                                      SizedBox(height: 10),
                                      FloatingLabelTextField(
                                        hintText: "Name",
                                        controller: userNameController,
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
                                      TextFormField(
                                        controller: dobController,
                                        decoration: InputDecoration(
                                          labelText: 'Select Date of Birth',
                                          hintText: 'Select Baby\'s Birth Date',
                                          prefixIcon:
                                              Icon(Icons.calendar_today),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                        readOnly: true,
                                        onTap: () => _selectDate(context),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Tooltip(
                                          message:
                                              'Dont worry parent! you can add your other children on your profile page inside the app',
                                          decoration: BoxDecoration(
                                            color: Colors.purple,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.info_outline,
                                                color: Colors.teal,
                                              ),
                                              SizedBox(
                                                width: 2,
                                              ),
                                              Text(
                                                'Why can I only add my one of my children?',
                                                style: TextStyle(
                                                    color: Colors.black45,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              )
                                            ],
                                          )),
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
                                      _registerUser();
                                    },
                                    child: Text(
                                      'SIGN IN',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  SizedBox(height: 90),
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
                            Navigator.pushNamed(context, 'login_screen');
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
