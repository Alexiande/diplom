import 'package:shared_preferences/shared_preferences.dart';

class LikeService {
  static const String _likedItemsKey = 'likedItems';

  // Получение списка лайкнутых элементов
  Future<Set<String>> getLikedItems() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_likedItemsKey)?.toSet() ?? <String>{};
  }

  // Добавление элемента в список лайкнутых
  Future<void> addLikedItem(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    final likedItems = await getLikedItems();
    if (likedItems.add(itemId)) { // добавляем только если itemId еще нет
      await prefs.setStringList(_likedItemsKey, likedItems.toList());
    }
  }

  // Удаление элемента из списка лайкнутых
  Future<void> removeLikedItem(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    final likedItems = await getLikedItems();
    if (likedItems.remove(itemId)) { // удаляем только если itemId был в списке
      await prefs.setStringList(_likedItemsKey, likedItems.toList());
    }
  }
}

