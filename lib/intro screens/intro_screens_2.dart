import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroScreens2 extends StatefulWidget {
  const IntroScreens2({super.key});

  @override
  State<IntroScreens2> createState() => _IntroScreens2State();
}

class _IntroScreens2State extends State<IntroScreens2> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: Center(
       child: Lottie.network('https://lottie.host/5bafd6dd-1aa9-4181-b575-3ee5a2a39cca/9unFSBlMH4.json'),
      ),
    );
  }
}