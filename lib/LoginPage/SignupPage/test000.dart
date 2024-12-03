import 'package:flutter/material.dart';

class DynamicBabyEntry extends StatefulWidget {
    static String id = 'test000_screen';


  @override
  _DynamicBabyEntryState createState() => _DynamicBabyEntryState();
}

class _DynamicBabyEntryState extends State<DynamicBabyEntry> {
  final List<Widget> _babyEntries = []; // To hold the dynamically created widgets

  void _addBabyEntry() {
    final babyNameController = TextEditingController();
    final babyGenderController = TextEditingController();

    setState(() {
      _babyEntries.add(
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: FloatingLabelTextField(
                    hintText: "Name",
                    controller: babyNameController,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: FloatingLabelTextField(
                    hintText: "Gender",
                    controller: babyGenderController,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            CalculateAge(),
            SizedBox(height: 20),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dynamic Baby Entries")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _babyEntries.length,
                itemBuilder: (context, index) => _babyEntries[index],
              ),
            ),
            ElevatedButton(
              onPressed: _addBabyEntry,
              child: Text("Add Baby Entry"),
            ),
          ],
        ),
      ),
    );
  }
}

class FloatingLabelTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  FloatingLabelTextField({required this.hintText, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: hintText,
        border: OutlineInputBorder(),
      ),
    );
  }
}

class CalculateAge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("Age calculation here"); // Placeholder for the CalculateAge widget
  }
}
