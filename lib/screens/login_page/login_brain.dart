import 'dart:convert';
import 'package:go_parent/utilities/constants.dart';
import 'package:crypto/crypto.dart';
import 'dart:math';
import 'package:go_parent/services/database/local/helpers/user_helper.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class LoginBrain {
  final UserHelper userHelper;
  LoginBrain(this.userHelper);


  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }


  String _generatePassword() {
    const length = 8;
    const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#%";
    Random random = Random();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)])
        .join();
  }


  Future<bool> loginUser(String email, String password) async {
    String hashedInput = _hashPassword(password);
    final user = await userHelper.getUserByEmail(email.trim());

    if (user != null && user.password == hashedInput) {
      return true;
    }
    return false;
  }


Future<bool> recoverUserAccount(String email) async {
    final user = await userHelper.getUserByEmail(email.trim());
    if (user == null) {
      return false;
    }

    String newPassword = _generatePassword();
    String hashedPassword = _hashPassword(newPassword);

    bool updated = await userHelper.updateUserPassword(email, hashedPassword);
    if (!updated) {
      return false;
    }

    await emailService.sendEmail(
      to: email,
      subject: "Account Recovery",
      body: "Your new password is: $newPassword\nPlease change it after logging in.",
    );

    return true;
  }



}
