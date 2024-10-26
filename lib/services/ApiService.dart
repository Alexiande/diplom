import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = 'https://api.spoonacular.com/recipes';
  static const String apiKey = '86f698483d5745ccbedd654f56397c61'; // Ваш API ключ

  // Метод для получения списка рецептов по названию блюда
  Future<List<dynamic>> fetchRecipesByName(String query) async {
    final response = await http.get(
      Uri.parse('$apiUrl/complexSearch?apiKey=$apiKey&query=$query&number=10'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['results']; // Возвращаем список рецептов
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  // Метод для получения списка рецептов по умолчанию
  Future<List<dynamic>> fetchItems() async {
    final response = await http.get(
      Uri.parse('$apiUrl/complexSearch?apiKey=$apiKey&number=10'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      // Добавляем получение времени приготовления для каждого рецепта
      for (var item in jsonResponse['results']) {
        // Получаем детали рецепта для каждого элемента
        final recipeDetails = await fetchRecipeDetails(item['id']);
        item['readyInMinutes'] = recipeDetails['preparationTime'];
      }
      return jsonResponse['results']; // Возвращаем список рецептов
    } else {
      throw Exception('Failed to load items');
    }
  }

  // Метод для получения рецептов по категории и тегу
  Future<List<dynamic>> fetchItemsByCategoryAndTag({String? category, String? tag}) async {
    final String categoryFilter = category != null ? '&type=$category' : '';
    final String tagFilter = tag != null ? '&tags=$tag' : '';
    final response = await http.get(
      Uri.parse('$apiUrl/complexSearch?apiKey=$apiKey$categoryFilter$tagFilter&number=10'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['results']; // Возвращаем список рецептов
    } else {
      throw Exception('Failed to load items');
    }
  }


  // Метод для получения информации о рецепте по его идентификатору
  Future<Map<String, dynamic>> fetchRecipeDetails(int recipeId) async {
    final response = await http.get(
      Uri.parse('$apiUrl/$recipeId/information?apiKey=$apiKey'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return {
        'image': jsonResponse['image'],
        'title': jsonResponse['title'],
        'author': jsonResponse['creditsText'], // Имя автора
        'authorAvatar': jsonResponse['image'], // Картинка автора (можно заменить на аватар)
        'preparationTime': jsonResponse['readyInMinutes'].toString() + ' min', // Время приготовления
        'likes': jsonResponse['aggregateLikes'], // Количество лайков
        'description': jsonResponse['summary'], // Описание
        'ingredients': jsonResponse['extendedIngredients']
            .map((ingredient) => ingredient['original'])
            .toList(), // Список ингредиентов
      };
    } else {
      throw Exception('Failed to load recipe details');
    }
  }
}


