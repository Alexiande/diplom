import 'package:shared_preferences/shared_preferences.dart';

class HistoryService {
  // Сохранение нового поискового запроса
  Future<void> saveSearchHistory(String query) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('searchHistory') ?? [];
    if (!history.contains(query)) {
      history.add(query);
    }
    await prefs.setStringList('searchHistory', history);
  }

  // Получение истории поиска
  Future<List<String>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('searchHistory') ?? [];
  }

  // Очистка истории поиска
  Future<void> clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('searchHistory');
  }
}
