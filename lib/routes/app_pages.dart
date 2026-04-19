import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:skills_app/features/auth/binding/binding.dart';
import 'package:skills_app/features/service/screen/service_screen.dart';
import 'package:skills_app/features/skill/binding/add_skill_binding.dart';
import 'package:skills_app/features/skill/screen/add_skill_screen.dart';
import 'package:skills_app/features/wishlist/screen/wishlist_screen.dart';

import '../features/auth/screen/auth_screen.dart';
import '../features/auth/screen/intro_screen.dart';
import '../features/category/binding/category_binding.dart';
import '../features/category/screen/category_screen.dart';
import '../features/chat/binding/chat_binding.dart';
import '../features/chat/screen/chat_screen.dart';
import '../features/dashboard/binding/dashboard_binding.dart';
import '../features/dashboard/screen/dashboard_screen.dart';
import '../features/location/binfing/location_binding.dart';
import '../features/location/screen/location_permission_screen.dart';
import '../features/search/binding/service_search_binding.dart';
import '../features/search/screen/search_screen.dart';
import '../features/service/binding/service_details_binding.dart';
import '../features/service/screen/service_details_screen.dart';
import '../features/wishlist/binding/wishlist_binding.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: '/intro',
      page: () => const IntroScreen(),
    ),

    GetPage(
      name: '/auth',
      page: () => AuthScreen(),
      binding: AuthBinding()
    ),

    GetPage(
        name: '/location',
        page: () => LocationPermissionScreen(),
        binding: LocationBinding()
    ),

    GetPage(
      name: '/dashboard',
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
    ),

    GetPage(
      name: '/category',
      page: () => CategoryScreen(
        categoryId: Get.parameters['id'] ?? '',
        category: Get.parameters['name'] ?? '',
      ),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: '/service',
      page: () => ServiceScreen(
        subcategoryId: Get.parameters['id'] ?? '',
      ),
    ),

    GetPage(
      name: '/service-details',
      page: () => ServiceDetailsScreen(serviceId: Get.parameters['id']!),
      binding: ServiceDetailsBinding(),
    ),

    GetPage(
      name: '/search',
      page: () => SearchScreen(),
      binding: ServiceSearchBinding(),
    ),

    GetPage(
      name: '/wishlist',
      page: () => WishlistScreen(),
      binding: WishlistBinding(),
    ),


    GetPage(
      name: '/add-skill',
      page: () {
        final args = Get.arguments ?? {};

        return AddSkillScreen(
          isEdit: args["isEdit"] ?? false,
          serviceData: args["serviceData"],
        );
      },
      binding: AddSkillBinding(),
    ),

    GetPage(
      name: '/chat',
      page: () => ChatScreen(),
      binding: ChatBinding(),
    ),

  ];
}