import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import this to format the date

class CalculateAge extends StatefulWidget {
  const CalculateAge({super.key});

  @override
  State<CalculateAge> createState() => _CalculateAgeState();
}

class _CalculateAgeState extends State<CalculateAge> {
  DateTime? _selectedDate;
  final TextEditingController dobController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextFormField(
          controller: dobController,
          decoration: InputDecoration(
            labelText: 'Select Date of Birth',
            hintText: 'Select Baby\'s Birth Date',
            prefixIcon: Icon(Icons.calendar_today),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          readOnly: true,
          onTap: () => _selectDate(context),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  @override
  void dispose() {
    dobController.dispose();
    super.dispose();
  }
}
