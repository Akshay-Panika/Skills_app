import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skills_app/routes/app_pages.dart';
import 'features/auth/helper/auth_preferences.dart';
import 'features/auth/helper/intro_preferences.dart';
import 'features/location/controller/location_controller.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(LocationController(), permanent: true);

  await IntroPreferences.init();
  await AuthPreferences.init();

  final introSeen = IntroPreferences.isIntroSeen();
  final isLoggedIn =  AuthPreferences.isLoggedIn();

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