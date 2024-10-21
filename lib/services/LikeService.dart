import 'package:shared_preferences/shared_preferences.dart';

class LikeService {
  static const String likedItemsKey = 'likedItems';

  // Метод для получения списка лайкнутых элементов
  Future<Set<String>> getLikedItems() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(likedItemsKey)?.toSet() ?? {};
  }

  // Метод для добавления элемента в список лайкнутых
  Future<void> addLikedItem(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    final likedItems = await getLikedItems();
    likedItems.add(itemId);
    prefs.setStringList(likedItemsKey, likedItems.toList());
  }

  // Метод для удаления элемента из списка лайкнутых
  Future<void> removeLikedItem(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    final likedItems = await getLikedItems();
    likedItems.remove(itemId);
    prefs.setStringList(likedItemsKey, likedItems.toList());
  }
}
