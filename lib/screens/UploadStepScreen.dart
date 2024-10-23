import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadStepScreen extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Возврат на предыдущий экран
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 22.0,
                  color: Color(0xFF2E3E5C),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: '1',
                    style: TextStyle(
                      color: Color(0xFF2E3E5C), // Цвет для "1"
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(
                    text: '/2',
                    style: TextStyle(
                      color: Color(0xFF9FA5C0), // Цвет для "/2"
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView( // Позволяет прокручивать содержимое
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20), // Уменьшено расстояние от верха
            Center(
              child: GestureDetector(
                onTap: () async {
                  // Открытие выбора фото
                  final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
                  if (photo != null) {
                    // Обработка выбранного фото
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 170,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueGrey.shade100, width: 1, style: BorderStyle.solid), // Тонкий пунктир
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo_rounded, size: 50, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          'Add Cover Photo',
                          style: TextStyle(
                            fontSize: 17.0,
                            color: Color(0xFF2E3E5C),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '(up to 12 Mb)',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
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
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFD0DBEA), width: 1, style: BorderStyle.solid), // Окантовка
                borderRadius: BorderRadius.circular(32.0),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Enter food name',
                  filled: true,
                  fillColor: Colors.white, // Цвет фона поля ввода
                  border: InputBorder.none, // Убираем стандартную границу
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
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFD0DBEA), width: 1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Tell a little about your food',
                  filled: true,
                  fillColor: Colors.white, // Цвет фона поля ввода
                  border: InputBorder.none, // Убираем стандартную границу
                ),
                maxLines: 3,
              ),
            ),
            const SizedBox(height: 24),
            RichText(
              text: TextSpan(
                children: const [
                  TextSpan(
                    text: 'Cooking Duration ',
                    style: TextStyle(
                      fontSize: 17.0,
                      color: Color(0xFF2E3E5C), // Цвет для "Cooking Duration"
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '(in minutes)',
                    style: TextStyle(
                      color: Color(0xFF9FA5C0), // Новый цвет для "(in minutes)"
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
                    activeTrackColor: const Color(0xFF5E6ED8), // Новый цвет ползунка
                    inactiveTrackColor: const Color(0xFFD0DBEA), // Цвет неактивной линии
                    thumbColor: const Color(0xFF5E6ED8), // Цвет ползунка
                    trackHeight: 8.0, // Увеличенная ширина линии ползунка
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0), // Размер ползунка
                  ),
                  child: Slider(
                    value: 30,
                    min: 10,
                    max: 60,
                    divisions: 5,
                    label: '30',
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Действие для следующего шага
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5E6ED8), // Цвет кнопки
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  minimumSize: const Size(double.infinity, 70), // Увеличенный размер кнопки
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true, // Обработка изменения размера экрана
    );
  }
}
