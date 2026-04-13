import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skills_app/core/constant/app_color.dart';
import 'package:skills_app/core/constant/app_size.dart';
import 'package:skills_app/core/widget/flutter_toast.dart';
import 'package:skills_app/core/widget/my_appbar.dart';
import '../../../core/widget/app_card.dart';
import '../../../core/widget/app_dilog.dart';
import '../../auth/helper/auth_preferences.dart';
import '../../help_support/screen/help_support_screen.dart';
import '../../notification/screen/notification_screen.dart';
import '../../skill/screen/skill_screen.dart';
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

  final userProfileController = Get.find<UserProfileController>();


  @override
  void initState() {
    super.initState();
    if (userProfileController.userProfile.value == null) {
      _loadUserProfile();
    }
  }

  Future<void> _loadUserProfile() async {
    final userId = await AuthPreferences.getUserId();
    if (userId != null) {
      userProfileController.fetchUserProfile(userId);
    } else {
      FlutterToast.error("User not logged in");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surface,
      appBar : myAppBar(
        backgroundColor: AppColor.primary,
        title: 'Account',
        centerTitle: false,
        titleColor: AppColor.white,
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
        ],
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
                _MenuTile(
                  icon: Icons.favorite_border_rounded,
                  title: "Wishlist",
                  subtitle: "Saved services",
                  onTap: () => Get.toNamed('/wishlist'),
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
                SizedBox(height: context.sWidth*0.2),
              ]),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildHeader(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Positioned.fill(child: Column(
          children: [
            Expanded(
              child: Container(
                color: AppColor.primary,
              ),
            ),
            Expanded(child: SizedBox())
          ],
        )),
        AppCard(
          color: AppColor.white,
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.only(
            left: 16,right: 16,top: 16
          ),
          child: Obx(() {
            final loading = userProfileController.isLoading.value;
            final profile = userProfileController.userProfile.value;

            if (loading) {
              return profileCard(null, isLoading: true);
            }

            return profileCard(profile);
          }),
        )
      ],
    );
  }

  Widget profileCard(UserProfileModel? profile, {bool isLoading = false}) {
    return Column(
      children: [
        CircleAvatar(
          radius: context.sHeight * 0.04,
          backgroundColor: AppColor.primary,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: CachedNetworkImage(
              imageUrl: (profile?.userImage != null &&
                  profile!.userImage!.trim().isNotEmpty)
                  ? profile.userImage!
                  : "",

              fit: BoxFit.cover,
              width: context.sHeight * 0.077,
              height: context.sHeight * 0.077,

              placeholder: (context, url) => CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                child: FaIcon(FontAwesomeIcons.circleUser, color: AppColor.primary),
              ),

              errorWidget: (context, url, error) => CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                child: FaIcon(FontAwesomeIcons.circleUser, color: AppColor.primary),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        isLoading
            ? AppCard(height: 12, width: 100, color: Colors.grey.shade300, margin: EdgeInsets.zero,padding: EdgeInsets.zero,)
            : Text(
          (profile?.userName?.isNotEmpty ?? false)
              ? profile!.userName!
              : "Guest User",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: context.text14,
            color: AppColor.title,
          ),
        ),
        const SizedBox(height: 6),

        isLoading
            ? AppCard(height: 10, width: 150, color: Colors.grey.shade300, margin: EdgeInsets.zero,padding: EdgeInsets.zero,)
            : Text(
          (profile?.userBio?.isNotEmpty ?? false)
              ? profile!.userBio!
              : "No Profile Found",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: context.text12,
            color: AppColor.subtitle,
          ),
        ),

        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isLoading
                ? AppCard(height: 10, width: 80, color: Colors.grey.shade300, margin: EdgeInsets.zero,padding: EdgeInsets.zero,)
                : Text(
              "00-00-2026",
              style: TextStyle(fontSize: context.text12),
            ),

            isLoading
                ? AppCard(height: 30, width: 80, color: Colors.grey.shade300,  margin: EdgeInsets.zero,padding: EdgeInsets.zero,)
                : AppCard(
              color: AppColor.primary,
              margin: EdgeInsets.zero,
              borderRadius: 10,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Row(
                children: [
                  const Icon(Icons.edit, size: 18, color: Colors.white),
                  const SizedBox(width: 6),
                  Text(
                    "Edit",
                    style: TextStyle(
                      fontSize: context.text12,
                      color: AppColor.white,
                    ),
                  ),
                ],
              ),
              onTap: () => Get.to(() => BasicInfoScreen()),
            ),
          ],
        ),
      ],
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
      Get.deleteAll();
      Get.offAllNamed('/auth');
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