import 'package:flutter/material.dart';
import 'features/auth/screen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skill App',
      debugShowCheckedModeBanner: false,
      home:  SplashScreen(),
    );
  }
}
