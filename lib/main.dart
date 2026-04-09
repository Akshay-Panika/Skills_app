import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skills_app/routes/app_pages.dart';
import 'features/auth/helper/auth_preferences.dart';
import 'features/auth/screen/auth_screen.dart';
import 'features/auth/screen/intro_screen.dart';
import 'features/dashboard/screen/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  final introSeen = prefs.getBool('intro_seen') ?? false;
  final isLoggedIn = await AuthPreferences.isLoggedIn();

  String initialRoute;

  if (!introSeen) {
    initialRoute = '/intro';
  } else if (!isLoggedIn) {
    initialRoute = '/auth';
  } else {
    initialRoute = '/dashboard';
  }

  runApp(MyApp(initialRoute: initialRoute));
}
class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      getPages: AppPages.pages,
    );
  }
}