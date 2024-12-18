import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/FirestoreService.dart';

class ProfileScreen extends StatefulWidget {
  final String userEmail;

  ProfileScreen({required this.userEmail});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  TextEditingController bioController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    print('Loading user data...');
    final userSnapshot = await _firestoreService.getUserByEmail(widget.userEmail);
    if (userSnapshot != null && userSnapshot.exists) {
      print('User data found!');
      setState(() {
        userData = userSnapshot.data() as Map<String, dynamic>;
        nameController.text = userData?['name'] ?? 'user_${widget.userEmail.hashCode}';
        bioController.text = userData?['bio'] ?? 'Who’s great?';
      });
    } else {
      print('No user data found, creating defaults...');
      setState(() {
        userData = {};  // Пустая карта, чтобы обновить UI
        nameController.text = 'user_${widget.userEmail.hashCode}';
        bioController.text = 'Who’s great?';
      });
    }
  }



  Future<void> _saveBio() async {
    if (userData != null) {
      // Обновляем профиль, если данные уже есть в Firestore
      await _firestoreService.updateUserProfile(
        userData!['userId'], // Убедитесь, что userId есть в данных
        {'bio': bioController.text, 'name': nameController.text},
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile updated successfully!")),
      );
    } else {
      // Создаем новый документ, если данных нет
      await _firestoreService.createUserProfile({
        'userEmail': widget.userEmail,
        'name': nameController.text,
        'bio': bioController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile created successfully!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Profile")),
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
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
              onPressed: _saveBio,
              child: Text(userData == null ? "Create Profile" : "Save Profile"),
            ),
          ],
        ),
      ),
    );
  }
}
