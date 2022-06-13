import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static var sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> saveData({
    required String key,
    required String value,
  }) async {
    return await sharedPreferences.setString(key, value);
  }

  static String getData({
    required String key,
  }) {
    return sharedPreferences.getString(key);
  }
}
