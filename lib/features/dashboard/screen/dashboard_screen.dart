import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:skills_app/core/constant/app_size.dart';
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
  Future<bool> _onWillPop() async {
    if (_currentIndex != 0) {
      setState(() => _currentIndex = 0);
      return false;
    } else {
      return await _showExitDialog();
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Color(0xffF7F8FA),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _screens[_currentIndex],
            Obx(() {
              bool isScrollingDown = _scrollStatusController.status.value == "Scrolling Down";

              return Container(
                height: context.sHeight*0.08,
                color: Colors.transparent,
                child: Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: AnimatedSlide(
                        duration: const Duration(milliseconds: 300),
                        offset: isScrollingDown
                            ? const Offset(0, 1.5) // hide
                            : const Offset(0, 0), // show
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
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
                                        ? Color(0xFF0D6E6E)
                                        : Colors.grey),
                              ),
                              IconButton(
                                onPressed: () => setState(() => _currentIndex = 1),
                                icon: FaIcon(FontAwesomeIcons.comment,
                                    color: _currentIndex == 1
                                        ? Color(0xFF0D6E6E)
                                        : Colors.grey),
                              ),
                              IconButton(
                                onPressed: () => setState(() => _currentIndex = 2),
                                icon: FaIcon(FontAwesomeIcons.ad,
                                    color: _currentIndex == 2
                                        ? Color(0xFF0D6E6E)
                                        : Colors.grey),
                              ),
                              IconButton(
                                onPressed: () => setState(() => _currentIndex = 3),
                                icon: FaIcon(FontAwesomeIcons.user,
                                    color: _currentIndex == 3
                                        ? Color(0xFF0D6E6E)
                                        : Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Right button always visible
                    Container(
                      padding:  EdgeInsets.only(left: context.sWidth*0.02),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0D6E6E),
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
      ),
    );
  }
  Future<bool> _showExitDialog() async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Exit App?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Are you sure you want to exit the app?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0D6E6E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        "Exit",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ) ?? false;
  }}

