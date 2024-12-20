import 'package:flutter/material.dart';
import 'package:diplom/services/ApiService.dart';
import 'package:diplom/services/LikeService.dart';
import 'package:diplom/screens/UploadStepScreen.dart';
import 'package:diplom/screens/ProfileScreen.dart';
import 'package:diplom/screens/SearchScreen.dart';
import 'package:diplom/widgets/RecipeCard.dart';

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
          MaterialPageRoute(builder: (context) => ProfileScreen(userId: widget.userId)),
        );
      }
    });
  }

  Future<List<dynamic>> _filterItems() async {
    List<String> tags = [];
    if (selectedCategory != 'All') {
      tags.add(selectedCategory.toLowerCase());
    }
    tags.add('diet'); // Общий тег "diet"

    String tagString = tags.join(',');

    return await apiService.fetchItemsByCategoryAndTag(
      category: selectedCategory == 'All' ? null : selectedCategory,
      tag: tagString,
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
        preferredSize: const Size.fromHeight(100.0),
        child: Container(
          padding: const EdgeInsets.only(top: 40),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: GestureDetector(
              onTap: () {
                // При нажатии на строку поиска открываем экран поиска
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
              child: Container(
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
                      child: Text(
                        'Search',
                        style: TextStyle(
                          color: Color(0xFF2E3E5C),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            automaticallyImplyLeading: false, // Убираем стрелку назад
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16), // Отступ сверху для разделения AppBar и контента
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
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.7,
                    ),
                    padding: const EdgeInsets.all(16.0),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final item = snapshot.data![index];
                      LikeService likeService = LikeService();
                      return RecipeCard(
                        title: item['title'],
                        imageUrl: item['image'],
                        time: '${item['readyInMinutes']} min',
                        category: selectedCategory,
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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}


