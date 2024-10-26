import 'package:flutter/material.dart';
import 'package:diplom/services/ApiService.dart'; // Импортируйте ваш ApiService
import 'package:cached_network_image/cached_network_image.dart';

class RecipeScreen extends StatefulWidget {
  final int recipeId; // Идентификатор рецепта

  const RecipeScreen({Key? key, required this.recipeId}) : super(key: key);

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  late Future<Map<String, dynamic>> recipeDetails;
  bool isAppBarVisible = true;

  @override
  void initState() {
    super.initState();
    recipeDetails = ApiService().fetchRecipeDetails(widget.recipeId); // Получаем детали рецепта
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: recipeDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data found'));
          }

          final recipe = snapshot.data!;
          final imageUrl = recipe['image']; // Предполагается, что изображение хранится в поле 'image'

          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels > 100) {
                setState(() {
                  isAppBarVisible = false; // Скрываем кнопку "Назад"
                });
              } else {
                setState(() {
                  isAppBarVisible = true; // Показываем кнопку "Назад"
                });
              }
              return true;
            },
            child: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 300, // Высота развернутого AppBar
                      flexibleSpace: FlexibleSpaceBar(
                        background: CachedNetworkImage(
                          imageUrl: imageUrl ?? 'https://example.com/default_image.png',
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Center(child: Icon(Icons.error, color: Colors.red)),
                        ),
                      ),
                      pinned: false, // Делаем AppBar зафиксированным
                      backgroundColor: Colors.transparent, // Прозрачный фон
                      elevation: 0, // Убираем тень
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3), // Измените положение тени
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recipe['title'],
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(recipe['authorAvatar']),
                                  radius: 20,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    recipe['author'],
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Time: ${recipe['preparationTime']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Likes: ${recipe['likes']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              recipe['description'],
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Ingredients:',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            ListView.builder(
                              itemCount: recipe['ingredients'].length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(recipe['ingredients'][index]),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (isAppBarVisible) // Условно отображаем кнопку "Назад"
                  Positioned(
                    top: 40, // Расположение кнопки
                    left: 16, // Расположение кнопки
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Переход на предыдущий экран
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8), // Фон кнопки
                          borderRadius: BorderRadius.circular(50), // Круглая кнопка
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black, // Цвет стрелочки
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

