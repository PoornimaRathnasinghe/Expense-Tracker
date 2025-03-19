import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  File? _profileImage; // Store the selected image here
  final ImagePicker _picker = ImagePicker(); // Create an ImagePicker instance

  // Function to request gallery permission and pick an image
  Future<void> _pickImage() async {
    // Request permission to access the gallery
    PermissionStatus status = await Permission.photos.request();

    if (status.isGranted) {
      // Permission granted, allow user to pick an image
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path); // Update the profile picture
        });
      }
    } else if (status.isDenied) {
      // Handle permission denied
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission denied. Please allow access to gallery.')),
      );
      openAppSettings(); // Optionally, direct user to settings
    } else {
      // Handle permission permanently denied or restricted
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission is permanently denied.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Information'),
      ),
      body: Center(
        child: Column(
          children: [
            _profileImage != null
                ? Image.file(_profileImage!, height: 150, width: 150, fit: BoxFit.cover)
                : const Placeholder(fallbackHeight: 150, fallbackWidth: 150), // Show placeholder if no image is selected
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Upload Photo'),
            ),
          ],
        ),
      ),
    );
  }
}
