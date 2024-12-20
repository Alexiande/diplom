import 'package:diplom/screens/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UploadStepTwoScreen extends StatefulWidget {
  final String name;
  final String description;
  final String time;
  final String imagePath;

  const UploadStepTwoScreen({
    required this.name,
    required this.description,
    required this.time,
    required this.imagePath,
  });

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

  // Проверка, что все поля заполнены
  bool _areFieldsValid() {
    if (_stepController.text.isEmpty) return false;
    for (var ingredient in ingredients) {
      if (ingredient.isEmpty) return false;
    }
    return true;
  }

  // Функция для отправки данных в Firebase
  // Функция для отправки данных в Firebase
  Future<void> _submitData() async {
    if (_areFieldsValid()) {
      CollectionReference recipes = FirebaseFirestore.instance.collection('recipes');

      try {
        // Получаем текущего аутентифицированного пользователя
        User? user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          // Если пользователь не аутентифицирован, выводим ошибку
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You must be logged in to submit a recipe!')),
          );
          return;
        }

        // Добавляем рецепт в коллекцию
        await recipes.add({
          'name': widget.name,
          'description': widget.description,
          'time': widget.time,
          'imagePath': widget.imagePath,
          'ingredients': ingredients,
          'step': _stepController.text,
          'timestamp': FieldValue.serverTimestamp(),
          'userId': user.uid, // Связываем рецепт с пользователем
        });

        _showSuccessDialog(); // Показываем диалог о успешной загрузке

        // Переход на экран HomeScreen после успешной загрузки
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(userId: user.uid)),
        );
      } catch (e) {
        // В случае ошибки отображаем ошибку
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload data!')),
        );
      }
    } else {
      // Если не все поля заполнены, показываем ошибку
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
    }
  }



  // Отображение диалога об успешной загрузке
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Upload Successful'),
          content: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
              Text('Загрузка прошла успешно!'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Возврат на предыдущий экран
              },
            ),
          ],
        );
      },
    );
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
              color: Color(0xFF1FCC79),
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
                '2/2',
                style: TextStyle(
                  fontSize: 17,
                  color: Color(0xFF3E5481),
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
                color: Color(0xFF2E3E5C),
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
                      color: Color(0xFF2E3E5C),
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
                  backgroundColor: Color(0xFF3E5481),
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
                color: const Color(0xFFF4F5F7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(
                  Icons.camera_alt_outlined,
                  color: Color(0xFF3E5481),
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
                      backgroundColor: const Color(0xFFF4F5F7),
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    child: const Text(
                      'Back',
                      style: TextStyle(
                        color: Color(0xFF3E5481),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submitData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1FCC79),
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
