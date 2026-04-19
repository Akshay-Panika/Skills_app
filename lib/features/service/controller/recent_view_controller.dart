import 'dart:async';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentViewController extends GetxController {
  static const String key = "recent_views";

  var recentIds = <String>[].obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    loadRecentViews();
  }

  void startTracking(String id) {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 5), () {
      addRecent(id);
    });
  }

  void stopTracking() {
    _timer?.cancel();
  }

  Future<void> addRecent(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList(key) ?? [];
    list.remove(id);
    list.insert(0, id);
    if (list.length > 20) list = list.sublist(0, 20);
    await prefs.setStringList(key, list);
    recentIds.value = list;
  }

  Future<void> loadRecentViews() async {
    final prefs = await SharedPreferences.getInstance();
    recentIds.value = prefs.getStringList(key) ?? [];
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
    recentIds.clear();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}