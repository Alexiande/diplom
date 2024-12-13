import 'package:diplom/screens/RecipeScreen.dart';
import 'package:flutter/material.dart';
import 'package:diplom/services/ApiService.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:diplom/services/LikeService.dart';
import 'dart:ui';
import 'package:diplom/screens/UploadStepScreen.dart';
import 'package:diplom/screens/ProfileScreen.dart';

class HomePage extends StatefulWidget {
  final String userId;

  const HomePage({Key? key, required this.userId}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiService apiService = ApiService();
  late Future<List<dynamic>> items;

  int _selectedIndex = 0; // To store the current index
  String selectedCategory = 'All'; // Selected category

  @override
  void initState() {
    super.initState();
    items = apiService.fetchItems(); // Load data on initialization
  }

  // Method to handle navigation item taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) { // Проверяем, если выбрана кнопка загрузки
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UploadStepScreen()), // Переход на экран UploadStepScreen
        );
      }
      if (index == 4){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen(userEmail: 'userEmail')),

        );
      }
    });
  }

  Future<List<dynamic>> _filterItems() async {
    // Подготовим список тегов для фильтрации
    List<String> tags = [];
    if (selectedCategory != 'All') {
      tags.add(selectedCategory.toLowerCase()); // Преобразуем в нижний регистр
    }
    tags.add('diet'); // Добавляем общий тег "diet"

    // Преобразуем список тегов в строку с разделителем запятой
    String tagString = tags.join(',');

    return await apiService.fetchItemsByCategoryAndTag(
      category: selectedCategory == 'All' ? null : selectedCategory,
      tag: tagString, // Передаем строку тегов
    );
  }

  Color _getButtonColor(String category) {
    return selectedCategory == category ? const Color(0xFF4169E1) : const Color(0xFFF4F5F7);
  }

  Color _getButtonTextColor(String category) {
    return selectedCategory == category ? Colors.white : const Color(0xFF9FA5C0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0), // Увеличиваем высоту AppBar
        child: Container(
          padding: const EdgeInsets.only(top: 40), // Добавляем отступ сверху
          child: AppBar(
            backgroundColor: Colors.white, // Делаем AppBar белым
            elevation: 0,
            title: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(32.0),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          color: Color(0xFF2E3E5C),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            automaticallyImplyLeading: false, // Убираем стрелку назад
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16), // Отступ сверху для разделения AppBar и контента

          // Заголовок "Category"
          const Padding(
            padding: EdgeInsets.only(left: 15.0), // Отступ влево для заголовка
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Category',
                style: TextStyle(
                  fontSize: 22.0,
                  color: Color(0xFF2E3E5C),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8), // Небольшой отступ между заголовком и кнопками

          // Кнопки категорий
          Padding(
            padding: const EdgeInsets.only(left: 15.0), // Отступ влево для кнопок
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, // Выравнивание кнопок влево
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getButtonColor('All'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedCategory = 'All';
                    });
                  },
                  child: Text(
                    'All',
                    style: TextStyle(color: _getButtonTextColor('All')),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getButtonColor('Food'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedCategory = 'Food';
                      items = _filterItems(); // Перезагрузка данных при смене категории
                    });
                  },
                  child: Text(
                    'Food',
                    style: TextStyle(color: _getButtonTextColor('Food')),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getButtonColor('Drinks'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedCategory = 'Drinks'; // Или другая категория
                      items = _filterItems(); // Перезагрузка данных при смене категории
                    });
                  },
                  child: Text(
                    'Drinks',
                    style: TextStyle(color: _getButtonTextColor('Drinks')),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _filterItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Failed to load items'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No items found'));
                } else {
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Две колонки
                      crossAxisSpacing: 8.0, // Расстояние между колонками
                      mainAxisSpacing: 8.0, // Расстояние между строками
                      childAspectRatio: 0.7, // Соотношение сторон для карточек
                    ),
                    padding: const EdgeInsets.all(16.0),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final item = snapshot.data![index];
                      LikeService likeService = LikeService();
                      return RecipeCard(
                        title: item['title'],
                        imageUrl: item['image'],
                        time: '${item['readyInMinutes']} min', // Время можно получить из данных, если доступно
                        category: selectedCategory, // Передаем категорию
                        itemId: item['id'].toString(),
                        likeService: likeService,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex, // Текущий выбранный элемент
        selectedItemColor: Colors.blue, // Цвет для выбранного элемента
        unselectedItemColor: Colors.grey, // Цвет для невыбранных элементов
        onTap: _onItemTapped, // Обработчик изменения индекса
      ),
    );
  }
}




class RecipeCard extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String time;
  final String category; // Добавляем категорию
  final String itemId; // Уникальный идентификатор для рецепта
  final LikeService likeService;

  const RecipeCard({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.time,
    required this.category, // Инициализация категории
    required this.itemId,
    required this.likeService,
  }) : super(key: key);

  @override
  _RecipeCardState createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    _loadLikeStatus();
  }

  Future<void> _loadLikeStatus() async {
    final likedItems = await widget.likeService.getLikedItems();
    setState(() {
      isLiked = likedItems.contains(widget.itemId);
    });
  }

  Future<void> _toggleLike() async {
    setState(() {
      isLiked = !isLiked;
    });
    if (isLiked) {
      await widget.likeService.addLikedItem(widget.itemId);
    } else {
      await widget.likeService.removeLikedItem(widget.itemId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0), // Отступ вокруг карточки
      child: GestureDetector( // Используем GestureDetector для обработки нажатий
        onTap: () {
          // Здесь вы можете определить логику перехода на новый экран
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RecipeScreen(recipeId: int.parse(widget.itemId)),), // Преобразуем itemId в int
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // Смещение тени
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16), // Скругляем все углы
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      fit: BoxFit.cover,
                      height: 120, // Высота изображения
                      width: double.infinity,
                      placeholder: (context, url) => Container(
                        height: 120,
                        width: double.infinity,
                        child: const Center(
                          child: CircularProgressIndicator(), // Индикатор загрузки
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E3E5C),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.time,
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Color(0xFF9FA5C0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.grey,
                  ),
                  onPressed: _toggleLike,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}