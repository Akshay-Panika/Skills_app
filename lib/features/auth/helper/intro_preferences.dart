import 'package:shared_preferences/shared_preferences.dart';

class IntroPreferences {
  static SharedPreferences? _prefs;

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setIntroSeen() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    await prefs.setBool('intro_seen', true);
  }

  static bool isIntroSeen() {
    return _prefs?.getBool('intro_seen') ?? false;
  }
}