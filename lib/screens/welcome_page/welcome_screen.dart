// ignore_for_file: sort_child_properties_last
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_parent/screens/login_page/login_screen.dart';
import 'package:go_parent/screens/signup_page/signup_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  static String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late PageController _controller;
  Timer? _timer;
  int _currentPage = 0;

  final List<String> lottieUrls = [
    'https://lottie.host/90d2a137-9050-4283-a3ec-0f1a6316995a/Eqk19hkzMx.json',
    'https://lottie.host/5bafd6dd-1aa9-4181-b575-3ee5a2a39cca/9unFSBlMH4.json',
    'https://lottie.host/75c76fc8-a369-4b92-aefb-5f0f93ea99bd/TRSOulyWqv.json',
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: lottieUrls.length * 1000);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 6), (timer) {
      if (_controller.hasClients) {
        _controller.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    _startTimer();
  }

  // Detect horizontal swipe gestures manually
  void _onHorizontalDrag(DragEndDetails details) {
    if (details.primaryVelocity == null) return;
    _resetTimer();

    if (details.primaryVelocity! < 0) {
      _controller.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else if (details.primaryVelocity! > 0) {
      _controller.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB2DFDB),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/goparent_black_icon.png',
                    height: 30,
                    width: 30,
                  ),
                  SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                  ),
                  Text(
                    'GoParent',
                    style: TextStyle(
                      fontFamily: 'CodeNewRoman',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF009688),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: GestureDetector(
                onHorizontalDragEnd: _onHorizontalDrag,
                child: PageView.builder(
                  controller: _controller,
                  itemBuilder: (context, index) {
                    final effectiveIndex = index % lottieUrls.length;
                    return Lottie.network(
                      lottieUrls[effectiveIndex],
                      fit: BoxFit.contain,
                    );
                  },
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index % lottieUrls.length;
                    });
                  },
                ),
              ),
            ),
            SmoothPageIndicator(
              controller: _controller,
              count: lottieUrls.length,
              effect: WormEffect(
                dotColor: Colors.white,
                activeDotColor: Color(0xFF009688),
                dotHeight: 10,
                dotWidth: 10,
                type: WormType.thin,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Signup()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF009688),
                        minimumSize: const Size(double.infinity, 50),
                        foregroundColor: Colors.white,
                        textStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      child: const Text('SIGN UP FOR FREE'),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                     onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => LoginPage()));
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Color(0xFF009688), // Teal text color
                        backgroundColor:
                            Color(0xFFB2DFDB), // Background same as screen
                        minimumSize: const Size(double.infinity, 50),
                        padding: EdgeInsets.zero, // Flat button look
                      ),
                      child: const Text('SIGN IN'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
