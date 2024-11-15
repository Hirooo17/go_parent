// ignore_for_file: prefer_final_fields, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:go_parent/LoginPage/SignupPage/signup_screen.dart';
import 'package:go_parent/intro%20screens/intro_screens_1.dart';
import 'package:go_parent/intro%20screens/intro_screens_2.dart';
import 'package:go_parent/intro%20screens/intro_screens_3.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
// controller to keep track our page
  PageController _controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            controller: _controller,
            children: [
              IntroScreens1(),
              IntroScreens2(),
              IntroScreens3(),
            ],
          ),

          // dot indicator
          Container(
              alignment: Alignment(0, 0.90),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // skip
                  GestureDetector(
                      onTap: () {
                        _controller.jumpToPage(2);
                      },
                      child: Text('skip')),

                  SmoothPageIndicator(controller: _controller, count: 3),

                  // next or done
                  onLastPage ?
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context){
                              return Signup();
                            }));
                      },
                      child: Text('done')
                      
                      )
                      : GestureDetector(
                      onTap: () {
                        _controller.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeIn);
                      },
                      child: Text('next')), 
                      
                ],
              )),
        ],
      ),
    );
  }
}
