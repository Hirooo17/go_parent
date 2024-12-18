import 'dart:convert';
import 'package:go_parent/utilities/constants.dart';
import 'package:crypto/crypto.dart';
import 'dart:math';
import 'package:go_parent/services/database/local/helpers/user_helper.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class LoginBrain {
  final UserHelper userHelper;
  LoginBrain(this.userHelper);


  Future<bool> loginUser(String email, String password) async {
    String hashedInput = _hashPassword(password);
    final user = await userHelper.getUserByEmail(email.trim());

    if (user != null && user.password == hashedInput) {
      return true;
    }
    return false;
  }

  Future<bool> recoverUserAccount(String email) async {
    try {
      // Ensure email is trimmed
      email = email.trim();

      // Check if the user exists
      final user = await userHelper.getUserByEmail(email);
      if (user == null) {
        return false; // No user found
      }

      // Generate a new password and hash it
      String newPassword = _generatePassword();
      String hashedPassword = _hashPassword(newPassword);

      // Update the user's password
      int rowsUpdated = await userHelper.updateUserPassword(email, hashedPassword);
      if (rowsUpdated == 0) {
        return false; // Password update failed
      }

      // Create the email using FlutterEmailSender
      final Email recoveryEmail = Email(
        body: 'Your new password is: $newPassword\nPlease change it after logging in.',
        subject: 'Account Recovery',
        recipients: [email], // The user's email
        isHTML: false, // Set to true if you want to send HTML content
      );

      // Send the recovery email
      await FlutterEmailSender.send(recoveryEmail);

      return true; // Account recovery successful
    } catch (e) {
      print("Error during account recovery: $e");
      return false;
    }
  }




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

}
