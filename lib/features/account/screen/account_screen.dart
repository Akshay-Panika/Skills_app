import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skills_app/core/constant/app_color.dart';
import 'package:skills_app/core/constant/app_size.dart';
import 'package:skills_app/core/widget/flutter_toast.dart';
import 'package:skills_app/core/widget/my_appbar.dart';
import 'package:skills_app/features/auth/screen/auth_screen.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../../core/widget/app_card.dart';
import '../../../core/widget/app_dilog.dart';
import '../../ads/screen/ads_screen.dart';
import '../../auth/helper/auth_preferences.dart';
import '../../help_support/screen/help_support_screen.dart';
import '../../notification/screen/notification_screen.dart';
import '../controller/user_profile_controller.dart';
import '../model/user_profile_model.dart';
import 'basic_info_screen.dart';
import 'delete_account_screen.dart';


class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final UserProfileController controller = Get.put(UserProfileController());

  @override
  void initState() {
    super.initState();
    if (controller.userProfile.value == null) {
      _loadUserProfile();
    }
  }

  Future<void> _loadUserProfile() async {
    final userId = await AuthPreferences.getUserId();
    if (userId != null) {
      controller.fetchUserProfile(userId);
    } else {
      FlutterToast.error("User not logged in");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surface,
      appBar: myAppBar(
        title: 'My Account',
        backgroundColor: AppColor.primary,
        titleColor: AppColor.white,
          centerTitle: false,
          actions: [
          InkWell(
            onTap: () => Get.to(() => NotificationScreen()),
            child: Container(
              width: 36,
              height: 36,
              margin: EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),

        ]
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(context)),
          SliverToBoxAdapter(child: SizedBox(height: context.sHeight*0.01,),),
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _sectionLabel(context,"Your Information"),
                 SizedBox(height: context.sHeight*0.014),
                _MenuTile(
                  icon: Icons.person_outline_rounded,
                  title: "Profile",
                  subtitle: "Edit your personal info",
                  onTap: () => Get.to(() => BasicInfoScreen()),
                ),
                _MenuTile(
                  icon: Icons.campaign_outlined,
                  title: "My Ads",
                  subtitle: "Manage your listings",
                  onTap: () => Get.to(() => AdsScreen()),
                ),
                const _MenuTile(
                  icon: Icons.favorite_border_rounded,
                  title: "Wishlist",
                  subtitle: "Saved services",
                ),
                _MenuTile(
                  icon: Icons.headset_mic_outlined,
                  title: "Help & Support",
                  subtitle: "FAQs, chat & more",
                  onTap: () => Get.to(() => HelpSupportScreen()),
                ),
                _MenuTile(
                  icon: Icons.delete_forever, // icon for delete account
                  title: "Delete Account",
                  subtitle: "Permanently remove your account",
                  onTap: () {
                    Get.to(() => DeleteAccountScreen()); // navigate to your delete account screen
                  },
                ),
                SizedBox(height: context.sHeight*0.018),
                _sectionLabel(context,"Account"),
                SizedBox(height: context.sHeight*0.014),
                _MenuTile(
                  icon: Icons.logout_rounded,
                  title: "Sign Out",
                  subtitle: "Log out of your account",
                  isDestructive: true,
                  onTap: () => _showSignOutDialog(context),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
       color: AppColor.primary,
      padding: EdgeInsets.all(16),
      child:  Obx(() {
        final bool loading = controller.isLoading.value;
        final UserProfileModel? profile = controller.userProfile.value;

        return Row(
          spacing: 10,
          children: [
            CircleAvatar(
              radius: context.sHeight*0.036,
              backgroundColor: AppColor.white,
              child: ClipOval(
                child: profile?.userImage?.isNotEmpty == true
                    ? FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: profile!.userImage!,
                  width: context.sHeight*0.065,
                  height: context.sHeight*0.065,
                  fit: BoxFit.cover,
                )
                    : const Icon(Icons.person_outline_rounded, size: 34, color: Colors.white),
              ),
            ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loading
                        ? "Loading…"
                        : ((profile?.userName?.isNotEmpty ?? false)
                        ? profile!.userName
                        : "Guest User"),
                    style:  TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: context.text14,
                      color: AppColor.white,
                    ),
                  ),

                  Text(
                    loading ? "" : (profile?.userBio ?? ""),
                    style:  TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: context.text12,
                      color: AppColor.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _sectionLabel(BuildContext context,String text) {
    return Row(
      spacing: 10,
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: AppColor.primary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),

        Text(
          text,
          style:  TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: context.text14,
            color: AppColor.primary,
          ),
        ),
      ],
    );
  }

  void _showSignOutDialog(BuildContext context) async {
    final bool confirmed = await AppDialog.show(
      context,
      title: "Sign Out?",
      message: "Are you sure you want to sign out of your account?",
      cancelText: "Cancel",
      confirmText: "Sign Out",
    );
    if (confirmed) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Get.off(() => AuthScreen());
      FlutterToast.success("Signed out successfully");
    }
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool isDestructive;

  const _MenuTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconBg =
    isDestructive ? AppColor.error.withOpacity(0.1) : AppColor.surface;
    final Color iconColor = isDestructive ? AppColor.error : AppColor.primary;

    return AppCard(
      onTap: onTap,
      margin: EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        spacing: 10,
        children: [
          Container(
            width: context.sHeight*0.06,
            height: context.sHeight*0.06,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: context.sHeight*0.025),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: context.text14,
                    color: iconColor,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: TextStyle(fontSize: context.text12, color: AppColor.subtitle),
                  ),
                ],
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: AppColor.subtitle.withOpacity(0.6),
            size: context.sHeight*0.03,
          ),
        ],
      ),
    );
  }
}