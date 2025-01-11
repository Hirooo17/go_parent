import 'package:flutter/material.dart';
import 'package:go_parent/Screen/view%20profile/baby_info_provider.dart';
import 'package:go_parent/utilities/user_session.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../services/database/local/sqlite.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late BabyInfoProvider babyInfoProvider;

  late TextEditingController _nameController;
 
  List<Map<String, dynamic>> children = [];
  // List of TextEditingControllers for children
  List<TextEditingController> childNameControllers = [];
  List<TextEditingController> childAgeControllers = [];

  @override
  void initState() {
    super.initState();
    initializeProvider();
    _nameController = TextEditingController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  Future<void> initializeProvider() async {
    final db = await DatabaseService.instance.database;
    babyInfoProvider = BabyInfoProvider(db);
    await _loadChildrenData();
  }

  // Load children data and initialize controllers
  Future<void> _loadChildrenData() async {
    final userSession = UserSession();
    final userId = userSession.userId;
    if (userId != null) {
      final childrenData =
          await babyInfoProvider.getFormattedChildrenData(userId);
      setState(() {
        children = childrenData;

        // Clear previous controllers before reinitializing them
        childNameControllers.clear();
        childAgeControllers.clear();

        // Create a controller for each child
        for (var child in children) {
          childNameControllers.add(TextEditingController(text: child['name']));
          childAgeControllers.add(TextEditingController(text: child['age']));
        }
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  // Add a new child to the list
  void _addChild() {
    setState(() {
      children.add({
        'name': '',
        'age': '',
        'key': UniqueKey(),
      });
      childNameControllers.add(TextEditingController());
      childAgeControllers.add(TextEditingController());
    });
  }

  // Function to remove a child from the list
  void _removeChild(int index) {
    setState(() {
      children.removeAt(index);
      childNameControllers.removeAt(index);
      childAgeControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            _animationController.reverse().then((_) {
              Navigator.pop(context);
            });
          },
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final userId = UserSession().userId;
              if (_formKey.currentState!.validate()) {
                // Prepare children data before saving
                List<Map<String, dynamic>> updatedChildrenData = [];
                for (int i = 0; i < children.length; i++) {
                  updatedChildrenData.add({
                    'name': childNameControllers[i].text,
                    'age': childAgeControllers[i].text,
                  });
                }

                // Save profile changes
                babyInfoProvider.saveProfileChanges(userId!, updatedChildrenData);

                // Handle UI transition after saving
                _animationController.reverse().then((_) {
                  Navigator.pop(context);
                });
              }
            },
            child: const Text('Save', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                        child: _profileImage == null
                            ? Icon(Icons.person,
                                size: 60, color: Colors.grey[400])
                            : null,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: MaterialButton(
                        onPressed: _pickImage,
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(8),
                        shape: const CircleBorder(),
                        child: const Icon(Icons.camera_alt, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              _buildSectionTitle('Parent Name'),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter your name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 25),
              _buildSectionTitle('Children'),
             
                  Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: children.length,
                          itemBuilder: (context, index) {
                            return _buildChildCard(index);
                          },
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton.icon(
                          onPressed: () {
                            _addChild();
                          },
                          icon: const Icon(Icons.add_circle_outline),
                          label: const Text('Add Another Child'),
                        ),
                      ],
                  )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChildCard(int index) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: childNameControllers[index],
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: TextFormField(
                controller: childAgeControllers[index],
                decoration: InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () => _removeChild(index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}
