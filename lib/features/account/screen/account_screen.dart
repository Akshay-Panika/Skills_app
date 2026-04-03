import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skills_app/core/widget/flutter_toast_widget.dart';
import 'package:skills_app/features/auth/screen/auth_screen.dart';
import '../../ads/screen/ads_screen.dart';
import '../../auth/helper/auth_preferences.dart';
import '../controller/user_profile_controller.dart';
import '../model/user_profile_model.dart';
import 'basic_info_screen.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final UserProfileController controller = Get.put(UserProfileController());
  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final userId = await AuthPreferences.getUserId();
    if (userId != null) {
      controller.fetchUserProfile(userId);
    } else {
      FlutterToastWidget.error("User not logged in");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// PROFILE CARD
          Obx(() {
            if (controller.isLoading.value) {
              return Container(
                height: 200,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 8)
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.grey.withOpacity(.15),
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        size: 32,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Guest Id",
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                        SizedBox(height: 4),
                        Text("+91", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              );
            }

            final UserProfileModel? profile = controller.userProfile.value;

            return Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 8)
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.grey.withOpacity(.15),
                    backgroundImage: (profile?.userImage?.isNotEmpty ?? false)
                        ? NetworkImage(profile!.userImage!)
                        : null,
                    child: (profile?.userImage?.isEmpty ?? true)
                        ? const Icon(
                      Icons.image_not_supported_outlined,
                      size: 32,
                      color: Colors.grey,
                    )
                        : null,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (profile?.userName?.isNotEmpty ?? false)
                              ? profile!.userName
                              : 'Guest',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(profile?.userPhone ?? '',
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 18),

          /// YOUR INFORMATION TITLE
          const Text("Your Information",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),

          const SizedBox(height: 10),

          /// MENU LIST (OLX Style)
           _MenuTile(icon: Icons.person_outline, title: "Profile",onTap: () =>  Get.to(() => BasicInfoScreen()),),
           _MenuTile(icon: Icons.campaign_outlined, title: "My Ads",onTap: () =>  Get.to(() => AdsScreen()),),
          const _MenuTile(icon: Icons.favorite_border, title: "Wishlist"),
          const _MenuTile(icon: Icons.chat_bubble_outline, title: "Help & Support"),
          const _MenuTile(icon: Icons.card_giftcard, title: "Rewards"),
          _MenuTile(
            icon: Icons.logout,
            title: "Sign Out",
            onTap: () {
              _showSignOutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Sign Out"),
        content: const Text("Are you sure you want to sign out?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Close dialog
            },
            child:  Text("Cancel", style: TextStyle(color: Colors.red),),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () async{
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Get.off(() => AuthScreen());
              FlutterToastWidget.success("Signed out successfully");
            },
            child:  Text("Sign Out", style: TextStyle(color: Colors.blueAccent),),
          ),
        ],
      ),
    );
  }
}

/// ================= MENU TILE =================
class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const _MenuTile({required this.icon, required this.title, this.subtitle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black87),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}