import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  final bool isDarkMode;

  const ProfilePage({super.key, required this.isDarkMode});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  DateTime? selectedDate;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
    loadSavedData();
  }

  @override
  void didUpdateWidget(covariant ProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDarkMode != widget.isDarkMode) {
      setState(() {
        _isDarkMode = widget.isDarkMode;
      });
    }
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('name', nameController.text);
    prefs.setString('email', emailController.text);
    prefs.setString('address', addressController.text);
    if (selectedDate != null) {
      prefs.setString('dateOfBirth', selectedDate!.toIso8601String());
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Details Saved!')),
    );
  }

  Future<void> loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nameController.text = prefs.getString('name') ?? '';
      emailController.text = prefs.getString('email') ?? '';
      addressController.text = prefs.getString('address') ?? '';
      String? dateOfBirth = prefs.getString('dateOfBirth');
      if (dateOfBirth != null) {
        selectedDate = DateTime.parse(dateOfBirth);
      }
      String? photoURL = prefs.getString('photoURL');
      if (photoURL != null && photoURL.isNotEmpty) {
        _profileImage = File(photoURL);
      }
    });
  }

  void clearData() {
    setState(() {
      nameController.clear();
      emailController.clear();
      addressController.clear();
      selectedDate = null;
      _profileImage = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Details Cleared!')),
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('photoURL', pickedFile.path);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to pick image: $e")),
      );
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Information'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: signOut,
          ),
        ],
        backgroundColor: _isDarkMode ? Colors.black : Colors.blue,
      ),
      body: Container(
        color: _isDarkMode ? Colors.black : Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : const AssetImage('assets/profile_placeholder.png') as ImageProvider,
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: _isDarkMode ? Colors.white : Colors.blue),
                      onPressed: _pickImage,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              _buildTextField('Your Name', nameController),
              const SizedBox(height: 16.0),
              _buildTextField('Email', emailController),
              const SizedBox(height: 16.0),
              _buildTextField('Address', addressController),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: saveData,
                    child: const Text('Save'),
                  ),
                  ElevatedButton(
                    onPressed: clearData,
                    child: const Text('Clear'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        TextField(
          controller: controller,
          style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            filled: true,
            fillColor: _isDarkMode ? Colors.grey[800] : Colors.white,
          ),
        ),
      ],
    );
  }
}
