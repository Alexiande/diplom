import 'package:flutter/material.dart';

class RecipeScreen extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String category;
  final String time;
  final String authorName;
  final String authorAvatarUrl;
  final int likes;
  final String description;
  final List<String> ingredients;
  final List<String> steps;

  RecipeScreen({
    required this.imageUrl,
    required this.title,
    required this.category,
    required this.time,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.likes,
    required this.description,
    required this.ingredients,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Изображение блюда
            Container(
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Кнопка назад
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircleAvatar(
                backgroundColor: Colors.grey.withOpacity(0.5),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            // Информация о рецепте
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        category,
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 4),
                      Text(
                        time,
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(authorAvatarUrl),
                          ),
                          SizedBox(width: 8),
                          Text(authorName),
                          Spacer(),
                          Row(
                            children: [
                              Icon(Icons.thumb_up, color: Colors.blue),
                              SizedBox(width: 4),
                              Text('$likes'),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Description',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(description),
                      SizedBox(height: 16),
                      Text(
                        'Ingredients',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      ...ingredients.map((ingredient) => ListTile(
                        leading: Icon(Icons.check, color: Colors.green),
                        title: Text(ingredient),
                      )),
                      SizedBox(height: 16),
                      Text(
                        'Steps',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      ...steps.map((step) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(step),
                      )),
                    ],
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
