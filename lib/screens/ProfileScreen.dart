import 'package:flutter/material.dart';
import 'package:diplom/services/CloudService.dart';

class ProfileScreen extends StatefulWidget {
  final String userEmail;

  ProfileScreen({required this.userEmail});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final CloudService _cloudService = CloudService();
  TextEditingController bioController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = "user_${widget.userEmail.hashCode}";
    bioController.text = "Who’s great?";
  }

  Future<void> _saveProfile() async {
    try {
      await _cloudService.sendUserProfile(
        widget.userEmail,
        nameController.text,
        bioController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile updated successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update profile: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: bioController,
              decoration: InputDecoration(labelText: "Bio"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text("Save Profile"),
            ),
          ],
        ),
      ),
    );
  }
}

