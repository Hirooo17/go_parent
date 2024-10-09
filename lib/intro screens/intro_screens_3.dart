import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroScreens3 extends StatefulWidget {
  const IntroScreens3({super.key});

  @override
  State<IntroScreens3> createState() => _IntroScreens3State();
}

class _IntroScreens3State extends State<IntroScreens3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
       child: Lottie.network('https://lottie.host/75c76fc8-a369-4b92-aefb-5f0f93ea99bd/TRSOulyWqv.json'),
      ),
    );
  }
}