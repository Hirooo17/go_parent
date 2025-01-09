import 'dart:convert';
import 'package:go_parent/utilities/constants.dart';
import 'package:crypto/crypto.dart';
import 'dart:math';
import 'package:go_parent/services/database/local/helpers/user_helper.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:go_parent/utilities/user_session.dart';

class LoginBrain {
  final UserHelper userHelper;
  LoginBrain(this.userHelper);

  Future<bool> loginUser(String email, String password) async {
    String hashedInput = _hashPassword(password);
    final user = await userHelper.getUserByEmail(email.trim());

    if (user != null && user.password == hashedInput) {
      // Login successful, store userId in UserSession
      UserSession().setUser(user.userId); // Assuming user.userId contains the user's ID
      print("[DEBUG] User logged in successfully: ${user.userId}");
      return true;
    }
    return false;
  }


  Future<bool> recoverUserAccount(String email) async {
    try {
      if (!await userHelper.userExists(email)) {
      print('Email not found: $email');
      return false;
    }

      String newPassword = _generatePassword();
      String hashedPassword = kHashPassword(newPassword);

    bool isPassUpdated = await userHelper.updateUserPassword(email, hashedPassword);
    if (!isPassUpdated) {
      print('Failed to update password for email: $email');
      return false;
    }

      final smtpServer = gmail(kAppUsername, kAppPassword);

      final message = Message()
        ..from = Address(kAppUsername, 'GoParentApp')
        ..recipients.add(email)
        ..subject = 'Account Recovery'
        ..text = 'Your new password is: $newPassword\nPlease change it after logging in.';

      await send(message, smtpServer);

      print('Test email sent to: $email');
      return true;
    } catch (e) {
      print("Error during email sending: $e");
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
