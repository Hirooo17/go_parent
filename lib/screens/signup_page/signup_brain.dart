import 'package:flutter/material.dart';
import 'package:go_parent/services/database/local/helpers/baby_helper.dart';
import 'package:go_parent/services/database/local/models/user_model.dart';
import 'package:go_parent/services/database/local/helpers/user_helper.dart';
import 'package:go_parent/services/database/local/models/baby_model.dart';
import 'package:go_parent/utilities/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class SignupBrain {
  final UserHelper userHelper;
  final BabyHelper babyHelper;

  SignupBrain(this.userHelper, this.babyHelper);

  bool emailChecker(TextEditingController email, BuildContext context) {
    String emailCheck = email.text.trim();
    RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+$');

    if (emailRegex.hasMatch(emailCheck)) {
      return true;
    } else {
      _showAlert(
        context: context,
        title: "Invalid Email",
        description: "Please enter a valid email.",
      );
      return false;
    }
  }

  bool passwordChecker(TextEditingController password,
    TextEditingController confirmPassword, BuildContext context) {
    String pass = password.text.trim();
    String confirmpw = confirmPassword.text.trim();

    if (pass.length < 5) {
      _showAlert(
        context: context,
        title: "Invalid Password",
        description: "Password must be at least 5 characters long.",
      );
      return false;
    }

    if (!pass.contains(RegExp(r'[0-9]'))) {
      _showAlert(
        context: context,
        title: "Invalid Password",
        description: "Password must contain at least one number.",
      );
      return false;
    }

    if (pass != confirmpw) {
      _showAlert(
        context: context,
        title: "Passwords Do Not Match",
        description: "Please make sure both passwords are the same.",
      );
      return false;
    }
    return true;
  }

  int calculateAgeInMonths(TextEditingController dobController) {
    DateTime selectedDate = DateTime.parse(dobController.text);
    DateTime currentDate = DateTime.now();
    int months = currentDate.difference(selectedDate).inDays ~/ 30;
    return months;
  }

  Future<bool> signupUser({
    required TextEditingController usernameController,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController babyNameController,
    required TextEditingController babyDobController,
    required TextEditingController babyGenderController,
    required BuildContext context,
  }) async {
    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String babyName = babyNameController.text.trim();
    String babyDob = babyDobController.text.trim();
    String babyGender = babyGenderController.text.trim();

    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        babyName.isEmpty ||
        babyDob.isEmpty) {
      _showAlert(
        context: context,
        title: "Empty Fields",
        description: "Please fill in all required fields.",
      );
      return false;
    }


    final existingUsers = await userHelper.getAllUsers();
    if (existingUsers.any((user) => user.email == email)) {
      _showAlert(
        context: context,
        title: "Email Already Registered",
        description: "Please use a different email address.",
      );
      return false;
    }

    String hashedPassword = kHashPassword(password);

    final newUser = UserModel(
      username: username,
      email: email,
      password: hashedPassword,
      totalScore: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      int newUserId = await userHelper.insertUser(newUser);
      int babyAgeInMonths = calculateAgeInMonths(babyDobController);

      final newBaby = BabyModel(
          userId: newUserId,
          babyName: babyName,
          babyAge: babyAgeInMonths,
          babyGender: babyGender);

      await babyHelper.insertBaby(newBaby);
      return true;
    } catch (e) {
      _showAlert(
        context: context,
        title: "Signup Failed",
        description: "An error occurred while signing up. Please try again.",
      );
      return false;
    }
  }


  void _showAlert({
    required BuildContext context,
    required String title,
    required String description,
  }) {
    Alert(
      context: context,
      type: AlertType.error,
      title: title,
      desc: description,
      buttons: [
        DialogButton(
          child: const Text("OK", style: TextStyle(color: Colors.white)),
          onPressed: () => Navigator.pop(context),
        )
      ],
    ).show();
  }
}
