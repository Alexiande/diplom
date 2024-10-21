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
      return jsonResponse['results']; // Возвращаем список рецептов
    } else {
      throw Exception('Failed to load items');
    }
  }

  // Метод для получения рецептов по категории и тегу
  Future<List<dynamic>> fetchItemsByCategoryAndTag({String? category, String? tag}) async {
    final String categoryFilter = category != null ? '&type=$category' : '';
    final String tagFilter = tag != null ? '&tags=$tag' : ''; // Обновляем параметр на "tags"
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

  // Метод для получения истории поиска
  Future<List<dynamic>> fetchSearchHistory() async {
    // Пример запроса на получение истории (можно реализовать с использованием локального хранилища)
    return Future.delayed(Duration(seconds: 1), () => ['Pancakes', 'Salad', 'Sushi']);
  }
}

