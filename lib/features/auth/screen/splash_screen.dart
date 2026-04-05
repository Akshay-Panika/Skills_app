import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skills_app/core/constant/app_color.dart';
import '../../dashboard/screen/dashboard_screen.dart';
import '../helper/auth_preferences.dart';
import 'intro_screen.dart';
import 'auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {



  @override
  void initState() {
    super.initState();
    _checkIntroSeen();
  }

  Future<void> _checkIntroSeen() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool introSeen = prefs.getBool('intro_seen') ?? false;
    bool isLoggedIn = await AuthPreferences.isLoggedIn();


    await Future.delayed(const Duration(seconds: 2));

    if (!introSeen) {

      Get.off(() => const IntroScreen());

    } else if (isLoggedIn) {

      Get.off(() => const DashboardScreen());

    } else {

      Get.off(() => AuthScreen());

    }


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            FaIcon(
             FontAwesomeIcons.chalkboardTeacher,
              size: context.height*0.16,
              color: AppColor.primary,
            )
          ],
        ),
      ),
    );
  }
}