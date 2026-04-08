// import 'package:flutter/material.dart';
// import 'package:get/get_navigation/src/root/get_material_app.dart';
// import 'features/auth/screen/splash_screen.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'Skill App',
//       debugShowCheckedModeBanner: false,
//       home:  SplashScreen(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/auth/helper/auth_preferences.dart';
import 'features/auth/screen/auth_screen.dart';
import 'features/auth/screen/intro_screen.dart';
import 'features/dashboard/screen/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  final bool introSeen = prefs.getBool('intro_seen') ?? false;
  final bool isLoggedIn = await AuthPreferences.isLoggedIn();

  runApp(
    MyApp(
      startScreen: !introSeen
          ? const IntroScreen()
          : isLoggedIn
          ? const DashboardScreen()
          : AuthScreen(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget startScreen;

  const MyApp({super.key, required this.startScreen});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: startScreen,
    );
  }
}