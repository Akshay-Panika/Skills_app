import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:skills_app/core/constant/app_color.dart';
import 'package:skills_app/core/constant/app_size.dart';
import '../../../core/widget/app_dilog.dart';
import '../../account/screen/account_screen.dart';
import '../../ads/screen/ads_screen.dart';
import '../../chat/screen/chat_screen.dart';
import '../../home/controller/home_screen_controller.dart';
import '../../home/screen/home_screen.dart';
import '../../ads/screen/create_add_screen.dart';
import '../../location/controller/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:skills_app/core/constant/app_size.dart';
import '../../account/screen/account_screen.dart';
import '../../ads/screen/ads_screen.dart';
import '../../chat/screen/chat_screen.dart';
import '../../home/screen/home_screen.dart';
import '../../ads/screen/create_add_screen.dart';
import '../../location/controller/location_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final LocationController _locationController = Get.put(LocationController());
  final ScrollStatusController _scrollStatusController =
  Get.put(ScrollStatusController());

  int _currentIndex = 0;
  final _screens = [
    HomeScreen(),
    ChatScreen(),
    AdsScreen(),
    AccountScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _locationController.fetchLocation();
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
                    // Left nav bar
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
                          padding: EdgeInsets.symmetric(vertical: context.sWidth * 0.01),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _navIcon(FontAwesomeIcons.home, 0),
                              _navIcon(FontAwesomeIcons.comment, 1),
                              _navIcon(FontAwesomeIcons.ad, 2),
                              _navIcon(FontAwesomeIcons.user, 3),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Right "Add" button always visible
                    Container(
                      padding: EdgeInsets.only(left: context.sWidth * 0.03, right: context.sWidth * 0.03,top: context.sWidth * 0.01,bottom: context.sWidth * 0.01),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0D6E6E),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: IconButton(
                        onPressed: () => Get.to(() => CreateAddScreen()),
                        icon: const FaIcon(FontAwesomeIcons.plus, color: Colors.white),
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
        color: _currentIndex == index ? const Color(0xFF0D6E6E) : Colors.grey,
      ),
    );
  }
}


