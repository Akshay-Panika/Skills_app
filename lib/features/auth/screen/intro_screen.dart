import 'package:flutter/material.dart';
import 'package:skills_app/features/dashboard/screen/dashboard_screen.dart';

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
      "desc": "Help others by sharing what you know",
      "icon": Icons.volunteer_activism,
    },
    {
      "title": "Learn New Skills",
      "desc": "Discover and learn from people around you",
      "icon": Icons.menu_book,
    },
    {
      "title": "Grow Your Future",
      "desc": "Build confidence and create new opportunities",
      "icon": Icons.trending_up,
    },
  ];

  void _goToDashboard() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AuthScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:  BoxDecoration(
          color: Colors.lightBlueAccent.withOpacity(0.16)
          // gradient: LinearGradient(
          //   colors: [Colors.blueAccent, Colors.lightBlueAccent],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
        ),
        child: SafeArea(
          child: Column(
            children: [

              /// SKIP
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _goToDashboard,
                  child: const Text(
                    "Skip",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ),

              /// PAGES
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: pages.length,
                  onPageChanged: (index) =>
                      setState(() => currentIndex = index),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            pages[index]["icon"],
                            size: 130,
                            color: Colors.blueAccent,
                          ),
                          const SizedBox(height: 40),
                          Text(
                            pages[index]["title"],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            pages[index]["desc"],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              /// INDICATOR
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                      (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.all(4),
                    width: currentIndex == index ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
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
                    child: Text(
                      currentIndex == pages.length - 1
                          ? "Get Started"
                          : "Next",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}