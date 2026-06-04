import 'package:shared_preferences/shared_preferences.dart';

class FavoritesStorage {
  static const String _key = 'favorite_product_ids';

  static Future<Set<String>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    return list.toSet();
  }

  static Future<void> saveFavorites(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, ids.toList());
  }

  static Future<void> toggleFavorite(String productId) async {
    final current = await loadFavorites();
    if (current.contains(productId)) {
      current.remove(productId);
    } else {
      current.add(productId);
    }
    await saveFavorites(current);
  }
}
