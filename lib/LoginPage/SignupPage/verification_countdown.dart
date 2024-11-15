import 'package:flutter/material.dart';
import 'dart:async';

class VerificationCountdown extends StatefulWidget {
  const VerificationCountdown({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VerificationCountdown createState() => _VerificationCountdown();
}

class _VerificationCountdown extends State<VerificationCountdown> {
  late Timer _timer;
  int _secondsLeft = 59; 


   @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    setState(() {
      _secondsLeft = 59;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsLeft > 0) {
          _secondsLeft--;
        } else {
          _timer.cancel(); 
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Center(child: _secondsLeft > 0
            ? Text(
                '$_secondsLeft seconds left',
                style: TextStyle(fontSize: 16),
              )
            : GestureDetector(
                onTap: () {
                  startTimer();
                },
                child: Text(
                  'Resend',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black45,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),);
  }
}