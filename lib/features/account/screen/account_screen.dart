import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skills_app/core/widget/flutter_toast.dart';
import 'package:skills_app/features/auth/screen/auth_screen.dart';
import '../../ads/screen/ads_screen.dart';
import '../../auth/helper/auth_preferences.dart';
import '../../help_support/screen/help_support_screen.dart';
import '../../notification/screen/notification_screen.dart';
import '../controller/user_profile_controller.dart';
import '../model/user_profile_model.dart';
import 'basic_info_screen.dart';

// ─── Design Tokens (same as HomeScreen) ───────────────────────────────────────
class _C {
  static const primary     = Color(0xFF0D6E6E);
  static const primaryDark = Color(0xFF094F4F);
  static const accent      = Color(0xFFFFB347);
  static const surface     = Color(0xFFF4F7F7);
  static const card        = Color(0xFFFFFFFF);
  static const textDark    = Color(0xFF0D1F1F);
  static const textMid     = Color(0xFF4A6565);
  static const textLight   = Color(0xFF8AABAB);
  static const chipBg      = Color(0xFFE6F2F2);
  static const danger      = Color(0xFFE05757);
}

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
    _loadUserProfile();
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
      backgroundColor: _C.surface,
      body: CustomScrollView(
        slivers: [
          // ── Gradient Header ───────────────────────────────────────────────
          SliverToBoxAdapter(child: _buildHeader()),

          // ── Body ──────────────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _sectionLabel("Your Information"),
                const SizedBox(height: 10),
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

                const SizedBox(height: 16),
                _sectionLabel("Account"),
                const SizedBox(height: 10),

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

  // ── Header with gradient + profile card ────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_C.primaryDark, _C.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "My Account",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen(),)),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.notifications_none_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Profile card — floats over the gradient
            Obx(() {
              final bool loading = controller.isLoading.value;
              final UserProfileModel? profile = controller.userProfile.value;

              return Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _C.card,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: _C.primaryDark.withOpacity(0.18),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Avatar
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: _C.chipBg, width: 3),
                      ),
                      child: CircleAvatar(
                        radius: 34,
                        backgroundColor: _C.chipBg,
                        backgroundImage:
                        (!loading && (profile?.userImage?.isNotEmpty ?? false))
                            ? NetworkImage(profile!.userImage!)
                            : null,
                        child: loading ||
                            (profile?.userImage?.isEmpty ?? true)
                            ? const Icon(Icons.person_outline_rounded,
                            size: 34, color: _C.primary)
                            : null,
                      ),
                    ),

                    const SizedBox(width: 14),

                    // Name + phone
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
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: _C.textDark,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            loading ? "" : (profile?.userPhone ?? ""),
                            style: const TextStyle(
                              color: _C.textMid,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),


                  ],
                ),
              );
            }),

            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: _C.primary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 14,
            color: _C.textDark,
          ),
        ),
      ],
    );
  }

  // ── Sign out dialog ────────────────────────────────────────────────────────
  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: _C.card,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Text(
                "Sign Out?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _C.textDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Are you sure you want to sign out\nof your account?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: _C.textMid,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: _C.chipBg, width: 1.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                            fontSize: 14,
                            color: _C.textMid,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.clear();
                        Navigator.of(context).pop();
                        Get.off(() => AuthScreen());
                        FlutterToast.success("Signed out successfully");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _C.danger,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      child: const Text(
                        "Sign Out",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Menu Tile ─────────────────────────────────────────────────────────────────
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
    final Color iconColor = isDestructive ? _C.danger : _C.primary;
    final Color iconBg =
    isDestructive ? _C.danger.withOpacity(0.08) : _C.chipBg;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: _C.primary.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // Icon container
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 14),
                // Title + subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: isDestructive ? _C.danger : _C.textDark,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: const TextStyle(
                              fontSize: 11, color: _C.textLight),
                        ),
                      ],
                    ],
                  ),
                ),
                // Arrow
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDestructive ? _C.danger.withOpacity(0.5) : _C.textLight,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}