import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../features/auth/screen/auth_screen.dart';
import '../features/auth/screen/intro_screen.dart';
import '../features/dashboard/screen/dashboard_screen.dart';
import '../features/home/binding/dashboard_binding.dart';
import '../features/service/binding/service_details_binding.dart';
import '../features/service/screen/service_details_screen.dart';
import '../features/skill/binding/service_list_by_user_binding.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: '/',
      page: () => const IntroScreen(),
    ),

    GetPage(
      name: '/auth',
      page: () => AuthScreen(),
    ),

    GetPage(
      name: '/dashboard',
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: '/service-details',
      page: () => ServiceDetailsScreen(serviceId: Get.parameters['id']!),
      binding: ServiceDetailsBinding(),
    ),


  ];
}