import 'package:flutter/material.dart';

import '../../account/screen/account_screen.dart';
import '../../account/screen/basic_info_screen.dart';
import '../../ads/screen/ads_screen.dart';
import '../../chat/screen/chat_screen.dart';
import '../../home/screen/home_screen.dart';
import '../../service/screen/add_service_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final _screens = [
    HomeScreen(),
    ChatScreen(),
    AdsScreen(),
    AccountScreen(),
  ];

  int _getBottomIndex() {
    if (_currentIndex == 0) return 0;
    if (_currentIndex == 1) return 1;
    if (_currentIndex == 2) return 3;
    return 4;
  }

  void _onTap(int index) {
    if (index == 2) return; // FAB space

    setState(() {
      if (index == 0) _currentIndex = 0;
      if (index == 1) _currentIndex = 1;
      if (index == 3) _currentIndex = 2;
      if (index == 4) _currentIndex = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          _screens[_currentIndex],
          InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BasicInfoScreen(),)),
            child: Container(
              width: 60,height: 60,
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blueAccent),
              ),
              child: Icon(Icons.person,color: Colors.blueAccent,),
            ),
          )
        ],
      ),

      floatingActionButton:InkWell(
        onTap:  () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) =>  AddServiceScreen()),
          );
        },
        child: Container(
            height: 40,width: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey,width: 0.3)
            ),
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _getBottomIndex(),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_outlined),
            activeIcon: Icon(Icons.chat),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: SizedBox.shrink(),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign_outlined),
            activeIcon: Icon(Icons.campaign),
            label: "My Ads",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Account",
          ),
        ],
      ),
    );
  }
}