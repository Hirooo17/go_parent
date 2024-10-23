import 'package:flutter/material.dart';
import 'package:flutter_easy_faq/flutter_easy_faq.dart';

class Faq extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Frequently Asked Questions"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(
              28.0), // You can adjust the padding as needed
          child: Column(
            children: [
              EasyFaq(
                question: "question?",
                answer: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua\nUt enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
