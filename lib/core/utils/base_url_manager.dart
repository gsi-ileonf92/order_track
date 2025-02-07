import 'package:shared_preferences/shared_preferences.dart';

class BaseUrlManager {
  static const String _baseUrlKey = 'base_url';

  static Future<void> saveBaseUrl(String url) async {
    final prefs = SharedPreferencesAsync();
    await prefs.setString(_baseUrlKey, url);
  }

  static Future<String?> getBaseUrl() async {
    final prefs = SharedPreferencesAsync();
    return prefs.getString(_baseUrlKey);
  }
}
