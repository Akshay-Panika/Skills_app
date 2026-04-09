import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'package:skills_app/core/constant/app_color.dart';
import '../../../core/constant/app_size.dart';
import '../../../core/widget/app_button.dart';
import 'auth_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<Map<String, dynamic>> pages = [
    {
      "title": "Share Your Skills",
      "desc":
      "Help others by sharing what you know. Teach, guide, and inspire your community while building confidence.",
      "icon": 'assets/intro/Share.json',
    },
    {
      "title": "Learn New Skills",
      "desc":
      "Discover new skills from people around you. Learn, grow, and improve yourself every day.",
      "icon": 'assets/intro/Education.json',
    },
    {
      "title": "Grow Your Future",
      "desc":
      "Build confidence and unlock new opportunities. Keep learning and move closer to your goals.",
      "icon": 'assets/intro/Growth.json',
    },
  ];
  void _goToDashboard() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('intro_seen', true);
    Get.offAllNamed('/auth');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Padding(
        padding:  EdgeInsets.all(context.sWidth*0.06),
        child: Column(
          children: [
            SizedBox(height: context.sHeight*0.06,),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (index) => setState(() => currentIndex = index),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white
                        ),
                        child: Lottie.asset(pages[index]["icon"]),
                      ),
                      SizedBox(height: context.sHeight*0.1,),
                      Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pages[index]["title"],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: context.text18,
                              fontWeight: FontWeight.bold,
                              color: AppColor.title,
                            ),
                          ),
                          Text(
                            pages[index]["desc"],
                            textAlign: TextAlign.start,
                            style:  TextStyle(
                              fontSize: context.text14,
                              color: AppColor.subtitle,
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                },
              ),
            ),

            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(
                    pages.length,
                        (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.all(4),
                      width: currentIndex == index ? context.sWidth*0.1 : context.sWidth*0.05,
                      height: context.sHeight*0.004,
                      decoration: BoxDecoration(
                        color: currentIndex == index ? AppColor.primary: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: context.sHeight*0.04,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: _goToDashboard,
                      child:  Text(
                        "Skip",
                        style: TextStyle(color: AppColor.primary,fontWeight: FontWeight.bold,fontSize: context.text14),
                      ),
                    ),
                    SizedBox(
                      width: context.sWidth*0.4,
                      child: AppButton(
                        text: currentIndex == pages.length - 1
                            ? "Get Started"
                            : "Next",
                        isLoading: false,
                        onPressed: () {
                          if (currentIndex == pages.length - 1) {
                            _goToDashboard();
                          } else {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          }
                        },
                      ),
                    ),

                  ],
                ),
                SizedBox(height: context.sHeight*0.04,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}