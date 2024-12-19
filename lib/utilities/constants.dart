import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

const String kAppUsername = 'goparent.team@gmail.com';
const String kAppPassword = 'lmqf hmpq viai pjbv ';

String kHashPassword(String password) {
  final bytes = utf8.encode(password);
  final hash = sha256.convert(bytes);
  return hash.toString();
}

// const double kDevieHeight = MediaQuery.of(context).size.height;
// const double kDeviceWidth = MediaQuery.of(context).size.width;

const kh1LabelTextStyle = TextStyle(
  fontSize: 32, // Approximate size for <h1>
  fontWeight: FontWeight.bold,
  fontFamily: 'CodeNewRoman',
);

const kh2LabelTextStyle = TextStyle(
  fontSize: 24, // Approximate size for <h2>
  fontWeight: FontWeight.bold,
  fontFamily: 'CodeNewRoman',
);

const kh3LabelTextStyle = TextStyle(
  fontSize: 20, // Approximate size for <h3>
  fontWeight: FontWeight.bold,
  fontFamily: 'CodeNewRoman',
);

const kh4LabelTextStyle = TextStyle(
  fontSize: 16, // Approximate size for <h4>
  fontWeight: FontWeight.bold,
  fontFamily: 'CodeNewRoman',
);
