import 'package:flutter/material.dart';
import 'package:skills_app/features/dashboard/screen/dashboard_screen.dart';
import 'package:lottie/lottie.dart';
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
      "Help others by sharing what you know and make a real difference in people’s lives. Teach your talents, guide beginners step-by-step, and inspire your community with practical knowledge. Build meaningful connections, gain recognition for your expertise, and grow your confidence while empowering others to succeed.",
      "icon": 'assets/intro/Share.json',
    },
    {
      "title": "Learn New Skills",
      "desc":
      "Discover and learn from people around you in a simple and engaging way. Explore new abilities, gain real-world knowledge, and improve yourself every day. Connect with mentors, ask questions, and keep growing so you stay prepared for future opportunities and challenges.",
      "icon": 'assets/intro/Education.json',
    },
    {
      "title": "Grow Your Future",
      "desc":
      "Build confidence and create new opportunities that shape your journey ahead. Expand your network, unlock your true potential, and move closer to your goals. With continuous learning and strong connections, you can create a brighter, more successful future for yourself.",
      "icon": 'assets/intro/Growth.json',
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
          color: Colors.white
        ),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (index) =>
                    setState(() => currentIndex = index),
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 50,),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white
                          ),
                          child: Lottie.asset(pages[index]["icon"]),
                        ),
                      ),
                      Expanded(child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pages[index]["title"],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              pages[index]["desc"],
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ))
                    ],
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
                  width: currentIndex == index ? 50 : 25,
                  height: 3,
                  decoration: BoxDecoration(
                    color: currentIndex == index ?Colors.blueAccent:Colors.grey.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _goToDashboard,
                    child:  Text(
                      "Skip",
                      style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold,fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    width: 150,
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
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}