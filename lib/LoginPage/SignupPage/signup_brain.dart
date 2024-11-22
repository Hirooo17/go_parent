import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SignupBrain {

  bool emailChecker(TextEditingController email, BuildContext context) {
    String emailCheck = email.text;
    RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

    if (emailRegex.hasMatch(emailCheck)) {
      return true;
    } else {
     Alert(
        context: context,
        type: AlertType.error,
        title: "Invalid Email",
        desc: "Please Enter a Valid Email.",
        buttons: [
          DialogButton(
            child: Text("OK", style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ).show();
      return false;
    }
  }


  bool passwordChecker(TextEditingController password,
      TextEditingController confirmpass, BuildContext context) {
    String pass = password.text;
    String confirmpw = confirmpass.text;

    if (pass.length < 5) {
      Alert(
        context: context,
        type: AlertType.error,
        title: "Invalid Password",
        desc: "Password must be at least 5 characters long",
        buttons: [
          DialogButton(
            child: Text("OK", style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ).show();
      return false;
    }

    if (!pass.contains(RegExp(r'[0-9]'))) {
      Alert(
        context: context,
        type: AlertType.error,
        title: "Invalid Password",
        desc: "Password must contain at least one number",
        buttons: [
          DialogButton(
            child: Text("OK", style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ).show();
      return false;
    }

    if (pass != confirmpw) {
      Alert(
          context: context,
          type: AlertType.error,
          title: "Invalid Passwords",
          desc: "Passwords Does Not Match",
          buttons: [
            DialogButton(
                child: Text("OK", style: TextStyle(color: Colors.white)),
                onPressed: () => Navigator.pop(context))
          ]).show();
      return false;
    }

    return true;
  }
}
