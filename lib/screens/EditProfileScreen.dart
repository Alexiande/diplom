import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileScreen extends StatefulWidget {
  final String userId;

  EditProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }


  // Метод для загрузки данных из Firestore
  void _loadUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();

      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>;

        setState(() {
          nameController.text = userData['name'] ?? 'Unknown';
          bioController.text = userData['bio'] ?? 'Who\'re great?';
        });
      } else {
        // Если документа нет, выводим сообщение
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User not found')));
      }
    } catch (error) {
      // Обработка ошибок при загрузке данных
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading data: $error')));
    }
  }

  // Метод для сохранения профиля
  void _saveProfile() async {
    try {
      DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(widget.userId);
      DocumentSnapshot userDoc = await userRef.get();

      if (!userDoc.exists) {
        // Если документа нет, создаем новый
        await userRef.set({
          'name': nameController.text,
          'bio': bioController.text,
        }).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile created')));
          Navigator.pop(context); // Возвращаемся на предыдущий экран
        });
      } else {
        // Если документ существует, обновляем его
        await userRef.update({
          'name': nameController.text,
          'bio': bioController.text,
        }).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated')));
          Navigator.pop(context); // Возвращаемся на предыдущий экран
        });
      }
    } catch (error) {
      // Обработка ошибок при сохранении данных
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving profile: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name:', style: TextStyle(fontSize: 16)),
            TextField(
              controller: nameController,
              decoration: InputDecoration(hintText: 'Enter your name'),
            ),
            SizedBox(height: 16),
            Text('Bio:', style: TextStyle(fontSize: 16)),
            TextField(
              controller: bioController,
              decoration: InputDecoration(hintText: 'Enter your bio'),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
