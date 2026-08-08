import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static SharedPreferences? _prefs;

  static Future<SharedPreferences> getInstance() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Key Constants
  static const String keyCart = 'suk_cart_items';
  static const String keyWishlist = 'suk_wishlist_items';
  static const String keyRecentlyViewed = 'suk_recently_viewed';
  static const String keyPriceHistory = 'suk_price_history';
  static const String keySearchHistory = 'suk_search_history';
  static const String keyAuthToken = 'suk_auth_token';
  static const String keyCachedProducts = 'suk_cached_products';

  static Future<void> saveString(String key, String value) async {
    final prefs = await getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final prefs = await getInstance();
    return prefs.getString(key);
  }

  static Future<void> saveJsonList(String key, List<dynamic> list) async {
    final prefs = await getInstance();
    await prefs.setString(key, jsonEncode(list));
  }

  static Future<List<dynamic>> getJsonList(String key) async {
    final prefs = await getInstance();
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) return [];
    try {
      return jsonDecode(raw) as List<dynamic>;
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveMap(String key, Map<String, dynamic> map) async {
    final prefs = await getInstance();
    await prefs.setString(key, jsonEncode(map));
  }

  static Future<Map<String, dynamic>?> getMap(String key) async {
    final prefs = await getInstance();
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static Future<void> remove(String key) async {
    final prefs = await getInstance();
    await prefs.remove(key);
  }
}
