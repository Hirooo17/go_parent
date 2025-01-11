import 'package:flutter/material.dart';
import 'package:go_parent/services/database/local/models/baby_model.dart';
import 'package:go_parent/services/database/local/sqlite.dart';
import 'package:sqflite/sqflite.dart';
import '../../services/database/local/helpers/baby_helper.dart';
import '../../utilities/user_session.dart';

class NewBabyScreen extends StatefulWidget {
  @override
  _NewBabyScreenState createState() => _NewBabyScreenState();
}

class _NewBabyScreenState extends State<NewBabyScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _selectedGender = 'Male';
  late final BabyHelper babyHelper;

  final List<String> genders = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  Future<void> _initializeDatabase() async {
    final db = await DatabaseService.instance.database;
    babyHelper = BabyHelper(db);
  }

  @override
  Widget build(BuildContext context) {
    final int? userId = UserSession().userId;

    if (userId == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'User not logged in',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Please log in first to continue'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFF5F8FF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF2E3E5C)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add New Baby',
          style: TextStyle(
            color: Color(0xFF2E3E5C),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Text(
                'Baby Information',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E3E5C),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Please fill in the details below',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 32),

              // Name Input
              _buildTextField(
                controller: _nameController,
                label: 'Baby Name',
                icon: Icons.child_care,
                hint: 'Enter baby\'s name',
              ),
              SizedBox(height: 24),

              // Gender Selection
              Text(
                'Gender',
                style: TextStyle(
                  color: Color(0xFF2E3E5C),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 12),
              Container(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: genders.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: ChoiceChip(
                        label: Text(genders[index]),
                        selected: _selectedGender == genders[index],
                        selectedColor: Color(0xFF4B8EFF),
                        onSelected: (selected) {
                          setState(() {
                            _selectedGender = genders[index];
                          });
                        },
                        labelStyle: TextStyle(
                          color: _selectedGender == genders[index]
                              ? Colors.white
                              : Colors.grey[600],
                        ),
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 24),

              // Age Input
              _buildTextField(
                controller: _ageController,
                label: 'Age',
                icon: Icons.cake,
                hint: 'Enter baby\'s age',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 40),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_nameController.text.isEmpty || _ageController.text.isEmpty) {
                      _showErrorSnackBar('Please fill in all fields');
                      return;
                    }

                    final newBaby = BabyModel(
                      userId: userId,
                      babyAge: int.tryParse(_ageController.text) ?? 0,
                      babyGender: _selectedGender,
                      babyName: _nameController.text,
                    );

                    final result = await babyHelper.insertBaby(newBaby);
                    if (result > 0) {
                      Navigator.pop(context, newBaby);
                      _showSuccessSnackBar('Baby added successfully');
                    } else {
                      _showErrorSnackBar('Failed to add baby');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4B8EFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Add Baby',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color(0xFF2E3E5C),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: Icon(icon, color: Color(0xFF4B8EFF)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}