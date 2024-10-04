import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = 'https://api.spoonacular.com/recipes/complexSearch'; // Пример URL для Spoonacular API
  static const String apiKey = '86f698483d5745ccbedd654f56397c61'; // Ваш API ключ

  Future<List<dynamic>> fetchItems() async {
    final response = await http.get(
      Uri.parse('$apiUrl?apiKey=$apiKey&number=10'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['results']; // Возвращаем список результатов
    } else {
      throw Exception('Failed to load items');
    }
  }
}
