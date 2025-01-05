// ignore_for_file: sort_child_properties_last, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_parent/services/database/local/helpers/user_helper.dart';
import 'package:go_parent/services/database/local/sqlite.dart';
import 'package:go_parent/screens/login_page/login_brain.dart';
import 'package:go_parent/screens/home_page/home_screen.dart';
import 'package:go_parent/utilities/constants.dart';
import 'package:go_parent/widgets/snackbar.dart';
import 'package:go_parent/widgets/text_field.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

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
  final screenSize = 700;
  late LoginBrain loginBrain;
  bool isLoading = false;
  bool? cbValue = false;


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailRecoveryController.dispose(); // Dispose the recovery controller
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _initializeLoginBrain();
  }

  Future<void> _initializeLoginBrain() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    final dbService = DatabaseService.instance;
    final db = await dbService.database;
    final userHelper = UserHelper(db);
    loginBrain = LoginBrain(userHelper);
}


  void handleLogin(BuildContext context, TextEditingController emailController, TextEditingController passwordController) async {
    bool loginSuccess = await loginBrain.loginUser(emailController.text, passwordController.text);

    if (loginSuccess) {
      final db = await DatabaseService.instance.database;
      final userHelper = UserHelper(db);
      final user = await userHelper.getUserByEmail(emailController.text);

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Homescreen(
              username: user.username,
              userId: user.userId!,
            ),
          ),
        );
      }
    } else {
      await Alert(
        context: context,
        type: AlertType.error,
        title: "Login Failed",
        desc: "Invalid username or password. Please try again.",
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
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: keyboardHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50,),
                SizedBox(
                  width: MediaQuery.of(context).size.width > 600
                      ? MediaQuery.of(context).size.width * 0.4
                      : MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height / 2.5,
                  child: Image.asset(
                    'assets/images/login.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                    width: 700,
                    child: TextFieldInput(
                        icon: Icons.email,
                        textEditingController: emailController,
                        hintText: 'Enter your email',
                        textInputType: TextInputType.emailAddress)),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 700,
                  child: TextFieldInput(
                    icon: Icons.lock,
                    textEditingController: passwordController,
                    hintText: 'Enter your password',
                    textInputType: TextInputType.text,
                    isPass: true,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Checkbox(
                          value: cbValue,
                          onChanged: (bool? newValue) {
                            setState(() {
                              cbValue = newValue;
                            });
                          },),
                        Text(
                          "Remember Me",
                          style: kh3LabelTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                Material(
                  elevation: 5.0,
                  color: Color(0xFF009688),
                  borderRadius: BorderRadius.circular(30.0),
                  child: MaterialButton(
                    onPressed: ()=> handleLogin(context, emailController, passwordController),
                    minWidth: screenSize * .4,
                    height: 50.0,
                    child: Text(
                      "LOG IN",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 250,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: GestureDetector(
                          onTap: () {
                            Alert(
                              context: context,
                              title: "Recover Your Account",
                              content: Column(
                                children: <Widget>[
                                  Text(
                                    "Please enter your email. We will generate a password for you to log in and send it to your email.",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  TextField(
                                    controller: emailRecoveryController,
                                    decoration: InputDecoration(
                                      icon: Icon(Icons.email),
                                      labelText: 'Email',
                                      hintText: 'Enter your email',
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                ],
                              ),
                              buttons: [
                                DialogButton(
                                  onPressed: () {
                                    String emailRecovery = emailRecoveryController.text; // Get the user input
                                    loginBrain.recoverUserAccount(emailRecovery);
                                  },
                                  child: Text(
                                    "Recover Password", // Appropriate name for the button
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ],
                            ).show();
                          },
                      ),
                    ),
                    SizedBox(width: 250,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't Have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, 'signup_screen');
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 30,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
