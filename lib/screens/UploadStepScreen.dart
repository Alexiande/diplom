import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:diplom/screens/UploadStepTwoScreen.dart';

class UploadStepScreen extends StatefulWidget {
  @override
  _UploadStepScreenState createState() => _UploadStepScreenState();
}

class _UploadStepScreenState extends State<UploadStepScreen> {
  final ImagePicker _picker = ImagePicker();
  double _sliderValue = 30;
  final TextEditingController _foodNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  XFile? _image; // Для хранения выбранного изображения

  // Функция для запроса разрешений и выбора изображения
  Future<void> _requestGalleryPermission(BuildContext context) async {
    PermissionStatus status = await Permission.photos.status;

    if (status.isGranted) {
      // Разрешение уже предоставлено, можно открыть галерею
      _openGallery();
    } else if (status.isDenied) {
      // Разрешение не предоставлено, запросим его
      PermissionStatus newStatus = await Permission.photos.request();
      if (newStatus.isGranted) {
        // Если разрешение предоставлено, откроем галерею
        _openGallery();
      } else {
        // Если разрешение отклонено, выводим сообщение
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Доступ к галерее запрещен')),
        );
      }
    } else if (status.isPermanentlyDenied) {
      // Если разрешение навсегда отклонено, предложим открыть настройки
      openAppSettings();
    }
  }

  Future<void> _openGallery() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      setState(() {
        _image = photo;
      });
    }
  }

  Future<void> _saveToFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пожалуйста, войдите в свой аккаунт')),
      );
      return;
    }

    // Путь к изображению по умолчанию
    String defaultImagePath = 'assets/images/default_image.png';

    // Если изображение не выбрано, используем изображение по умолчанию
    String imagePathToSave = _image != null ? _image!.path : defaultImagePath;

    CollectionReference recipes = FirebaseFirestore.instance.collection('recipes');

    await recipes.add({
      'userId': user.uid,
      'foodName': _foodNameController.text,
      'description': _descriptionController.text,
      'cookingDuration': _sliderValue.round(),
      'timestamp': FieldValue.serverTimestamp(),
      'imagePath': imagePathToSave, // Сохраняем путь к изображению
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Рецепт успешно сохранен')),
      );
      // Переход на следующий экран
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UploadStepTwoScreen(
            name: _foodNameController.text,
            description: _descriptionController.text,
            time: _sliderValue.round().toString(),
            imagePath: _image?.path ?? defaultImagePath, // Путь к изображению
          ),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при сохранении рецепта: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Color(0xFF5E6ED8),
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _requestGalleryPermission(context),
              child: Container(
                width: double.infinity,
                height: 170,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: _image == null
                      ? Image.asset(
                    'assets/images/default_image.png', // Правильный путь
                    fit: BoxFit.cover,
                  )
                      : Image.file(
                    File(_image!.path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Food Name',
              style: TextStyle(
                fontSize: 17.0,
                color: Color(0xFF2E3E5C),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFD0DBEA), width: 1),
                borderRadius: BorderRadius.circular(32.0),
              ),
              child: TextField(
                controller: _foodNameController,
                decoration: InputDecoration(
                  hintText: 'Enter food name',
                  hintStyle: const TextStyle(
                    color: Color(0xFF9FA5C0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 17.0,
                color: Color(0xFF2E3E5C),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFD0DBEA), width: 1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Tell a little about your food',
                  hintStyle: TextStyle(
                    color: Color(0xFF9FA5C0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: InputBorder.none,
                ),
                maxLines: 3,
              ),
            ),
            const SizedBox(height: 24),
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Cooking Duration ',
                    style: TextStyle(
                      fontSize: 17.0,
                      color: Color(0xFF2E3E5C),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '(in minutes)',
                    style: TextStyle(
                      color: Color(0xFF9FA5C0),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('<10', style: TextStyle(color: Color(0xFF5E6ED8), fontSize: 15, fontWeight: FontWeight.bold)),
                    Text('30', style: TextStyle(color: Color(0xFF5E6ED8), fontSize: 15, fontWeight: FontWeight.bold)),
                    Text('>60', style: TextStyle(color: Color(0xFF5E6ED8), fontSize: 15, fontWeight: FontWeight.bold)),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: const Color(0xFF5E6ED8),
                    inactiveTrackColor: const Color(0xFFD0DBEA),
                    thumbColor: const Color(0xFF5E6ED8),
                    trackHeight: 8.0,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                  ),
                  child: Slider(
                    value: _sliderValue,
                    min: 10,
                    max: 60,
                    divisions: 5,
                    label: _sliderValue.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        _sliderValue = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _saveToFirestore(); // Сохраняем данные в Firestore
                  if (_image != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UploadStepTwoScreen(
                          name: _foodNameController.text,
                          description: _descriptionController.text,
                          time: _sliderValue.round().toString(), // Преобразуем в строку
                          imagePath: _image!.path, // Путь к изображению
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Пожалуйста, выберите изображение')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5E6ED8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  minimumSize: const Size(200, 50),
                ),
                child: const Text(
                  'Next Step',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
