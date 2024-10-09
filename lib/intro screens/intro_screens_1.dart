import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroScreens1 extends StatefulWidget {
  const IntroScreens1({super.key});

  @override
  State<IntroScreens1> createState() => _IntroScreens1State();
}

class _IntroScreens1State extends State<IntroScreens1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
       child: Lottie.network('https://lottie.host/90d2a137-9050-4283-a3ec-0f1a6316995a/Eqk19hkzMx.json'),
      ),
    );
  }
}