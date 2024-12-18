import 'package:flutter/material.dart';
import 'package:diplom/services/ApiService.dart';
import 'package:diplom/screens/RecipeScreen.dart';

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

  // История поиска (для примера, можно заменить на реальное хранение)
  List<String> searchHistory = ['Pancakes', 'Salad', 'Sushi'];

  @override
  void initState() {
    super.initState();
    searchResults = Future.value([]);
  }

  // Метод для поиска
  void _search() {
    String query = searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        searchResults = Future.value([]);
      });
    } else {
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
    }
  }

  Color _getButtonColor(String category) {
    return category == 'All' ? const Color(0xFF4169E1) : const Color(0xFFF4F5F7);
  }

  Color _getButtonTextColor(String category) {
    return category == 'All' ? Colors.white : const Color(0xFF9FA5C0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120.0), // Увеличиваем высоту AppBar
        child: Container(
          padding: const EdgeInsets.only(top: 40), // Добавляем отступ сверху
          child: AppBar(
            backgroundColor: Colors.white, // Делаем AppBar белым
            elevation: 0,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF2E3E5C)),
                    onPressed: () {
                      Navigator.pop(context); // Возвращаемся на предыдущий экран
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
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      searchController.clear();
                      _search(); // Очищаем результаты поиска
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_horiz),
                    onPressed: () {
                      // Дополнительные действия
                    },
                  ),
                ],
              ),
            ),
            automaticallyImplyLeading: false, // Убираем стрелку назад по умолчанию
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0), // Отступы по бокам
        child: Column(
          children: [
            const SizedBox(height: 16), // Отступ сверху для разделения AppBar и контента

            // История поиска
            const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Search History',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildHistoryItem('Pancakes'),
                _buildHistoryItem('Salad'),
                _buildHistoryItem('Sushi'),
              ],
            ),

            // Предложения для поиска
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Search Suggestions',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  _buildSuggestionButton('Sushi'),
                  _buildSuggestionButton('Sandwich'),
                  _buildSuggestionButton('Seafood'),
                  _buildSuggestionButton('Fried Rice'),
                ],
              ),
            ),

            // Результаты поиска
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
                        return ListTile(
                          title: Text(item['title']),
                          subtitle: Text('Ready in ${item['readyInMinutes']} min'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecipeScreen(recipeId: item['id']),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Виджет для элемента истории поиска
  Widget _buildHistoryItem(String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Text(text),
            const Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }

  // Виджет для кнопки предложения для поиска
  Widget _buildSuggestionButton(String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[200],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
          ),
          onPressed: () {
            searchController.text = text;
            _search();
          },
          child: Text(
            text,
            style: const TextStyle(color: Color(0xFF2E3E5C)),
          ),
        ),
      ),
    );
  }
}
