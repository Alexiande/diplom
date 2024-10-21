import 'package:flutter/material.dart';
import 'package:diplom/services/ApiService.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  ApiService apiService = ApiService();
  late Future<List<dynamic>> items; // Объявляем переменную items

  int _selectedIndex = 0; // Чтобы хранить текущий индекс
  String selectedCategory = 'All'; // Выбранная категория

  @override
  void initState() {
    super.initState();
    items = apiService.fetchItems(); // Загружаем данные при инициализации
  }

  // Метод для обработки нажатий на элементы навигации
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Метод для фильтрации элементов по категории
  Future<List<dynamic>> _filterItems() async {
    final allItems = await items;
    if (selectedCategory == 'All') {
      return allItems;
    } else {
      return allItems.where((item) => item['category'] == selectedCategory).toList();
    }
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
          color: Colors.white, // Белый фон для AppBar
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

          // Заголовок "Categories"
          Padding(
            padding: const EdgeInsets.only(left: 15.0), // Отступ влево для заголовка
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Categories',
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
                      selectedCategory = 'Drinks';
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
                      return RecipeCard(
                        title: item['title'],
                        imageUrl: item['image'],
                        time: '>60 min', // Вы можете добавить время в JSON
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

class RecipeCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String time;

  const RecipeCard({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0), // Отступ вокруг карточки
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              imageBuilder: (context, imageProvider) => Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0), // Отступ вокруг текста
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0), // Отступ слева и справа
              child: Text(
                time,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
