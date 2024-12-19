import 'package:flutter/material.dart';
import 'package:diplom/services/ApiService.dart';
import 'package:diplom/screens/RecipeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diplom/services/LikeService.dart'; // Assuming you have a LikeService for managing likes
import 'package:diplom/widgets/RecipeCard.dart'; // Assuming you have the RecipeCard widget

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController searchController = TextEditingController();
  late Future<List<dynamic>> searchResults;
  bool isSearchingByIngredients = false;

  // История поиска
  List<String> searchHistory = [];
  bool isSearching = false;
  bool isFilterActive = false;  // Флаг для отображения фильтров

  @override
  void initState() {
    super.initState();
    searchResults = Future.value([]);
    _loadSearchHistory();
  }

  // Загрузка истории поиска из SharedPreferences
  void _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      searchHistory = prefs.getStringList('searchHistory') ?? [];
    });
  }

  // Сохранение истории поиска в SharedPreferences
  void _saveSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('searchHistory', searchHistory);
  }

  // Метод для поиска
  void _search() {
    String query = searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        searchResults = Future.value([]);
        isSearching = false;
      });
    } else {
      setState(() {
        isSearching = true;
      });

      if (isSearchingByIngredients) {
        // Поиск по ингредиентам
        setState(() {
          searchResults = apiService.fetchRecipesByIngredients(query);
        });
      } else {
        // Поиск по названию блюда
        setState(() {
          searchResults = apiService.fetchRecipesByName(query);
        });
      }

      // Добавляем запрос в историю поиска
      if (!searchHistory.contains(query)) {
        setState(() {
          searchHistory.add(query);
        });
        _saveSearchHistory();
      }
    }
  }

  // Виджет для отображения истории поиска
  Widget _buildSearchHistory() {
    return ListView.builder(
      itemCount: searchHistory.length,
      itemBuilder: (context, index) {
        final suggestion = searchHistory[index];
        return GestureDetector(
          onTap: () {
            searchController.text = suggestion;
            _search();
          },
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Text(
              suggestion,
              style: const TextStyle(fontSize: 16, color: Color(0xFF2E3E5C)),
            ),
          ),
        );
      },
    );
  }

  // Виджет для фильтров
  Widget _buildFilterOptions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            title: const Text('By Food'),
            leading: const Icon(Icons.restaurant_menu),
            onTap: () {
              setState(() {
                isSearchingByIngredients = false;
              });
              _search();
            },
          ),
          ListTile(
            title: const Text('By Ingredients'),
            leading: const Icon(Icons.food_bank),
            onTap: () {
              setState(() {
                isSearchingByIngredients = true;
              });
              _search();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120.0),
        child: Container(
          padding: const EdgeInsets.only(top: 40),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF2E3E5C)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              decoration: const InputDecoration(
                                hintText: 'Search',
                                hintStyle: TextStyle(
                                  color: Color(0xFF2E3E5C),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                border: InputBorder.none,
                              ),
                              onSubmitted: (_) => _search(),
                            ),
                          ),
                          // Кнопка для очищения поля поиска
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              _search();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Значок фильтра рядом с крестиком
                  IconButton(
                    icon: const Icon(Icons.filter_list, color: Color(0xFF2E3E5C)),
                    onPressed: () {
                      setState(() {
                        isFilterActive = !isFilterActive;  // Переключаем отображение фильтров
                      });
                    },
                  ),
                ],
              ),
            ),
            automaticallyImplyLeading: false,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Когда фильтры активированы, показываем карточки фильтра
            if (isFilterActive) ...[
              _buildFilterOptions(),
              const SizedBox(height: 16),
            ],

            // Отображение истории поиска
            if (searchHistory.isNotEmpty && !isSearching) ...[
              _buildSearchHistory(),
            ],

            // Когда ищем - показываем только результаты поиска
            if (isSearching) ...[
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: searchResults,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Failed to load recipes'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No results found'));
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final item = snapshot.data![index];
                          return RecipeCard(
                            title: item['title'],
                            imageUrl: item['image'],
                            time: '${item['readyInMinutes']} min',
                            category: item['category'] ?? 'Unknown',
                            itemId: item['id'].toString(),
                            likeService: LikeService(),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
