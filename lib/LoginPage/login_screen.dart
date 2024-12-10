import 'package:flutter/material.dart';
import 'package:go_parent/Database/Helpers/user_helper.dart';
import 'package:go_parent/Database/sqlite.dart';
import 'package:go_parent/LoginPage/login_brain.dart';
import 'package:go_parent/Screen/home_screen.dart';
import 'package:go_parent/Widgets/snackbar.dart';
import 'package:go_parent/Widgets/text_field.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
//import 'package:go_parent/authentication/auth.dart';

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
  final screenSize = 700;

  late LoginBrain loginBrain;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
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
                  height: 30,
                ),
                Material(
                  elevation: 5.0,
                  color: Color(0xFF009688),
                  borderRadius: BorderRadius.circular(30.0),
                  child: MaterialButton(
                    onPressed: () async {
                      if(await loginBrain.loginUser(emailController, passwordController, context)) {
                      Navigator.pushNamed(context, 'signup_screen');
                    }},
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
                            Navigator.pushNamed(context, 'password_recovery_screen');
                          },
                          child: Text(
                            "Forgot Password",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.teal,
                            ),
                          ),
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
