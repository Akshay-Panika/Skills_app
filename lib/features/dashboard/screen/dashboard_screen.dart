import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:skills_app/core/constant/app_color.dart';
import 'package:skills_app/core/constant/app_size.dart';

import '../../../core/widget/app_dilog.dart';

import '../../account/screen/account_screen.dart';
import '../../chat/screen/room_list_screen.dart';
import '../../home/controller/home_scroll_controller.dart';
import '../../home/screen/home_screen.dart';
import '../../skill/screen/skill_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ctrl = Get.find<HomeScrollController>();

  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _screens = [
      const HomeScreen(),
      const RoomListScreen(),
      const AdsScreen(),
      const AccountScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,

      onPopInvokedWithResult: (didPop, result) async {
        /// agar kisi aur tab par ho
        /// to home tab par aa jao
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });

          return;
        }

        /// home tab par exit dialog
        final shouldExit = await AppDialog.show(
          context,
          title: "Exit App?",
          message: "Are you sure you want to exit the app?",
          cancelText: "Cancel",
          confirmText: "Exit",
        );

        /// app exit
        if (shouldExit == true && mounted) {
          Navigator.of(context).pop();
        }
      },

      child: Scaffold(
        backgroundColor: AppColor.surface,

        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            /// screens
            IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),

            /// bottom nav
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,

              child: Container(
                height: context.sHeight * 0.086,
                color: Colors.transparent,

                child: Row(
                  spacing: context.sWidth * 0.02,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Obx(() {
                        final direction = ctrl.scrollDirection.value;

                        /// only hide on home tab
                        final shouldHide =
                            _currentIndex == 0 &&
                                direction == ScrollDirection.down;

                        return IgnorePointer(
                          ignoring: shouldHide,

                          child: AnimatedSlide(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,

                            offset: shouldHide
                                ? const Offset(0, 2)
                                : Offset.zero,

                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 250),
                              opacity: shouldHide ? 0 : 1,

                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,

                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(
                                      context.sWidth * 0.03,
                                    ),
                                    bottomRight: Radius.circular(
                                      context.sWidth * 0.03,
                                    ),
                                  ),

                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 0.3,
                                  ),
                                ),

                                padding: EdgeInsets.symmetric(
                                  vertical: context.sWidth * 0.01,
                                ),

                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,

                                  children: [
                                    _navIcon(
                                      FontAwesomeIcons.house,
                                      0,
                                    ),

                                    _navIcon(
                                      FontAwesomeIcons.comment,
                                      1,
                                    ),

                                    _navIcon(
                                      FontAwesomeIcons.chalkboardUser,
                                      2,
                                    ),

                                    _navIcon(
                                      FontAwesomeIcons.user,
                                      3,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    /// add button
                    Container(
                      padding: EdgeInsets.only(
                        left: context.sWidth * 0.03,
                        right: context.sWidth * 0.03,
                        top: context.sWidth * 0.01,
                        bottom: context.sWidth * 0.01,
                      ),

                      decoration: BoxDecoration(
                        color: AppColor.primary,

                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                            context.sWidth * 0.03,
                          ),
                          bottomLeft: Radius.circular(
                            context.sWidth * 0.03,
                          ),
                        ),
                      ),

                      child: IconButton(
                        onPressed: () {
                          Get.toNamed('/add-skill');
                        },

                        icon: const FaIcon(
                          FontAwesomeIcons.plus,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navIcon(FaIconData icon, int index) {
    final isSelected = _currentIndex == index;

    return IconButton(
      onPressed: () {
        setState(() {
          _currentIndex = index;
        });
      },

      icon: FaIcon(
        icon,
        color: isSelected
            ? AppColor.primary
            : Colors.grey,
      ),
    );
  }
}