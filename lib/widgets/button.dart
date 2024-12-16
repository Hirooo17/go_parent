import 'package:flutter/material.dart';

class MyButtons extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const MyButtons({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(20.0), // You can adjust this if needed
        child: Container(
          alignment: Alignment.center,
          height: 50, // Set a fixed height for a flatter appearance
          decoration: const BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.zero, // Square button
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
