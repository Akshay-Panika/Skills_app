import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skills_app/core/constant/app_color.dart';
import 'package:skills_app/core/constant/app_size.dart';
import 'package:skills_app/features/skill/repository/service_list_byuser_repository.dart';
import '../../../core/widget/app_dilog.dart';
import '../../account/screen/account_screen.dart';
import '../../category/controller/category_controller.dart';
import '../../chat/screen/chat_list_screen.dart';
import '../../home/controller/home_screen_controller.dart';
import '../../home/screen/home_screen.dart';
import '../../location/controller/location_controller.dart';
import '../../service/controller/service_list_controller.dart';
import '../../service/repository/service_list_repository.dart';
import 'package:get/get.dart';
import '../../skill/controller/service_delete_controller.dart';
import '../../skill/controller/service_list_by_user_controller.dart';
import '../../skill/screen/skill_screen.dart';
import '../../skill/screen/add_skill_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  final LocationController _locationController = Get.put(LocationController(), permanent: true);
  final ScrollStatusController _scrollStatusController = Get.put(ScrollStatusController(), permanent: true);

  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    Get.put(CategoryController(), permanent: true);
    Get.put(ServiceListController(ServiceListRepository()), permanent: true);
    Get.put(HomeScreenController(), permanent: true);
    Get.put(ServiceListByUserController(repository: ServiceListByUserRepository()), permanent: true);
    Get.put(ServiceDeleteController(), permanent: true);

    _screens = [
      HomeScreen(),
      ChatListScreen(),
      AdsScreen(),
      AccountScreen(),
    ];

    if (!_locationController.isLocationLoaded.value) {
      _locationController.fetchLocation();
    }
  }

  Future<bool> _onWillPop() async {
    if (_currentIndex != 0) {
      setState(() => _currentIndex = 0);
      return false;
    } else {
      return await AppDialog.show(
        context,
        title: "Exit App?",
        message: "Are you sure you want to exit the app?",
        cancelText: "Cancel",
        confirmText: "Exit",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColor.surface,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _screens[_currentIndex],
            Obx(() {
              bool isScrollingDown =
                  _scrollStatusController.status.value == "Scrolling Down";

              return Container(
                height: context.sHeight * 0.09,
                color: Colors.transparent,
                child: Row(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AnimatedSlide(
                        duration: const Duration(milliseconds: 300),
                        offset: isScrollingDown
                            ? const Offset(0, 1.5)
                            : Offset.zero,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                            color: Colors.white,
                            border: Border.all(color: Colors.grey, width: 0.3),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: context.sWidth * 0.01),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _navIcon(FontAwesomeIcons.home, 0),
                              _navIcon(FontAwesomeIcons.comment, 1),
                              _navIcon(FontAwesomeIcons.chalkboardTeacher, 2),
                              _navIcon(FontAwesomeIcons.user, 3),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: context.sWidth * 0.03,
                          right: context.sWidth * 0.03,
                          top: context.sWidth * 0.01,
                          bottom: context.sWidth * 0.01),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0D6E6E),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: IconButton(
                        onPressed: () => Get.to(() => AddSkillScreen()),
                        icon: const FaIcon(FontAwesomeIcons.plus,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _navIcon(FaIconData icon, int index) {
    return IconButton(
      onPressed: () => setState(() => _currentIndex = index),
      icon: FaIcon(
        icon,
        color: _currentIndex == index
            ? const Color(0xFF0D6E6E)
            : Colors.grey,
      ),
    );
  }
}