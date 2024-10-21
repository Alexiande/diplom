import 'package:shared_preferences/shared_preferences.dart';

class HistoryService {
  static Future<void> saveSearchQuery(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? history = prefs.getStringList('search_history') ?? [];
    if (!history.contains(query)) {
      history.add(query);
      await prefs.setStringList('search_history', history);
    }
  }

  static Future<List<String>> getSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('search_history') ?? [];
  }
}
