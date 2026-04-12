import 'package:shared_preferences/shared_preferences.dart';

class AuthPreferences {
  static SharedPreferences? _prefs;

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setLogin(int userId) async {
    await _prefs?.setInt("user_id", userId);
    await _prefs?.setBool("is_logged_in", true);
  }

  static bool isLoggedIn() {
    return _prefs?.getBool("is_logged_in") ?? false;
  }

  static int? getUserId() {
    return _prefs?.getInt("user_id");
  }

  static Future<void> logout() async {
    await _prefs?.clear();
  }
}