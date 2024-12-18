import 'package:flutter/material.dart';

class UploadStepTwoScreen extends StatefulWidget {
  const UploadStepTwoScreen({super.key});

  @override
  _UploadStepTwoScreenState createState() => _UploadStepTwoScreenState();
}

class _UploadStepTwoScreenState extends State<UploadStepTwoScreen> {
  final List<String> ingredients = [''];
  final TextEditingController _stepController = TextEditingController();

  void _addIngredient() {
    setState(() {
      ingredients.add('');
    });
  }

  Widget _buildIngredientInput(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.drag_indicator, color: Color(0xFF9FA5C0)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter ingredient',
                hintStyle: const TextStyle(
                  color: Color(0xFF9FA5C0),
                  fontSize: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: const BorderSide(
                    color: Color(0xFFD0DBEA),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14.0,
                  horizontal: 16.0,
                ),
              ),
              onChanged: (value) {
                ingredients[index] = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Color(0xFF1FCC79), // Зеленый цвет, подходящий для отмены
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                '1/2',
                style: TextStyle(
                  fontSize: 17,
                  color: Color(0xFF3E5481), // Синий цвет для отображения шага
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ingredients',
              style: TextStyle(
                fontSize: 17,
                color: Color(0xFF2E3E5C), // Основной темный цвет текста
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...List.generate(ingredients.length, (index) {
              return _buildIngredientInput(index);
            }),
            GestureDetector(
              onTap: _addIngredient,
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32.0),
                  border: Border.all(color: const Color(0xFFD0DBEA)),
                ),
                child: const Center(
                  child: Text(
                    '+ Ingredient',
                    style: TextStyle(
                      color: Color(0xFF2E3E5C), // Темный цвет для текста
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Steps',
              style: TextStyle(
                fontSize: 17,
                color: Color(0xFF2E3E5C),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const CircleAvatar(
                  radius: 12,
                  backgroundColor: Color(0xFF3E5481), // Цвет для круга (синий)
                  child: Text(
                    '1',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _stepController,
                    decoration: InputDecoration(
                      hintText: 'Tell a little about your food',
                      hintStyle: const TextStyle(
                        color: Color(0xFF9FA5C0),
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Color(0xFFD0DBEA),
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(16.0),
                    ),
                    maxLines: 3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F5F7), // Светлый фон для фотографии
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(
                  Icons.camera_alt_outlined,
                  color: Color(0xFF3E5481), // Синий цвет для иконки камеры
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF4F5F7), // Цвет кнопки "Back"
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    child: const Text(
                      'Back',
                      style: TextStyle(
                        color: Color(0xFF3E5481), // Синий для текста
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1FCC79), // Зеленый для кнопки "Next"
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
