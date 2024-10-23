import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SignupBrain {
  bool passwordChecker(TextEditingController password,
      TextEditingController confirmpass, BuildContext context) {
    String pass = password.text;
    String confirmpw = confirmpass.text;

    if (pass.length < 5) {
      Alert(
        context: context,
        title: "Invalid Password",
          content: Image.asset('assets/images/alert_icons/exclamation.png'),
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
          content: Image.asset('assets/images/alert_icons/exclamation.png'),
        title: "Invalid Password",
        desc: "Password must contain at least one number",
        buttons: [
          DialogButton(
            child:  Text("OK", style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ).show();
      return false;
    }

    if (pass != confirmpw) {
      Alert(
          context: context,
          content: Image.asset('assets/images/alert_icons/exclamation.png'),
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
