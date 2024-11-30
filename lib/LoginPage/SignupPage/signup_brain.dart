import 'package:flutter/material.dart';
import 'package:go_parent/Database/Models/user_model.dart';
import 'package:go_parent/Database/Helpers/user_helper.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class SignupBrain {
  final UserHelper userHelper;

  SignupBrain(this.userHelper);

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

  Future<bool> signupUser({
    required TextEditingController usernameController,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required BuildContext context,
    }) async {
    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
        _showAlert(
        context: context,
        title: "Empty Fields",
        description: "Please fill in all required fields.",
      );
      return false;
    }

    // Check if email already exists
    final existingUsers = await userHelper.getAllUsers();
    if (existingUsers.any((user) => user.email == email)) {
        _showAlert(
        context: context,
        title: "Email Already Registered",
        description: "Please use a different email address.",
      );
      return false;
    }

    // Hash the password
    String hashedPassword = _hashPassword(password);

    // Create user
    final newUser = UserModel(
      username: username,
      email: email,
      password: hashedPassword,
      totalScore: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      await userHelper.insertUser(newUser);
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

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
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
