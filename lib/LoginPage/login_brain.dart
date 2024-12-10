import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:go_parent/Database/Helpers/user_helper.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginBrain {
  final UserHelper userHelper;

  LoginBrain(this.userHelper);

      String _hashPassword(String password) {
      final bytes = utf8.encode(password);
      final hash = sha256.convert(bytes);
      return hash.toString();
    }

  Future<bool> loginUser(TextEditingController email, TextEditingController password, BuildContext context) async {
    String emailtxt = email.text.trim();
    String passwordtxt = password.text.trim();
    final user = await userHelper.getUserByEmail(emailtxt);

    if (user != null) {
      String hashedinput = _hashPassword(passwordtxt);

      if (user.password == hashedinput) {
        await Alert(
          context: context,
          type: AlertType.success,
          title: "Login Successful",
          desc: "Welcome to Goparent!, redirecting you to homescreen...",
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
        Navigator.pushReplacementNamed(context, "home_screen");
        return true;
      } else {
        await Alert(
          context: context,
          type: AlertType.error,
          title: "Invalid username or password",
          desc: "Please try again.",
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
    } else {
      await Alert(
        context: context,
        type: AlertType.error,
        title: "User doesn't exist",
        desc: "Please try again.",
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
    return false;
  }
}
