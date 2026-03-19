import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../account/screen/account_screen.dart';
import '../../ads/screen/ads_screen.dart';
import '../../chat/screen/chat_screen.dart';
import '../../home/controller/home_screen_controller.dart';
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
  final ScrollStatusController _scrollStatusController = Get.put(ScrollStatusController());

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7F8FA),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          _screens[_currentIndex],
          Obx(() {
            bool isScrollingDown = _scrollStatusController.status.value == "Scrolling Down";

            return Container(
              height: 80,
              color: Colors.transparent,
              child: Row(
                children: [
                  Expanded(
                    child: AnimatedSlide(
                      duration: const Duration(milliseconds: 300),
                      offset: isScrollingDown
                          ? const Offset(0, 1.5) // hide
                          : const Offset(0, 0), // show
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(color: Colors.grey, width: 0.3),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              onPressed: () => setState(() => _currentIndex = 0),
                              icon: FaIcon(FontAwesomeIcons.home,
                                  color: _currentIndex == 0
                                      ? Colors.blueAccent
                                      : Colors.grey),
                            ),
                            IconButton(
                              onPressed: () => setState(() => _currentIndex = 1),
                              icon: FaIcon(FontAwesomeIcons.comment,
                                  color: _currentIndex == 1
                                      ? Colors.blueAccent
                                      : Colors.grey),
                            ),
                            IconButton(
                              onPressed: () => setState(() => _currentIndex = 2),
                              icon: FaIcon(FontAwesomeIcons.ad,
                                  color: _currentIndex == 2
                                      ? Colors.blueAccent
                                      : Colors.grey),
                            ),
                            IconButton(
                              onPressed: () => setState(() => _currentIndex = 3),
                              icon: FaIcon(FontAwesomeIcons.user,
                                  color: _currentIndex == 3
                                      ? Colors.blueAccent
                                      : Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Right button always visible
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Get.to(() => CreateAddScreen());
                      },
                      icon: const FaIcon(FontAwesomeIcons.plus, color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          })
        ],
      ),
    );
  }
}