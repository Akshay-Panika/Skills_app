import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skills_app/core/constant/app_color.dart';
import 'package:skills_app/core/constant/app_size.dart';
import 'package:skills_app/core/widget/app_button.dart';
import 'package:skills_app/core/widget/app_card.dart';
import 'package:skills_app/core/widget/flutter_toast.dart';
import 'package:skills_app/features/location/controller/location_controller.dart';

class LocationPermissionScreen extends StatelessWidget {
  LocationPermissionScreen({super.key});

  final _locationController = Get.find<LocationController>();

  @override
  Widget build(BuildContext context) {
    final w = context.sWidth;
    final h = context.sHeight;

    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              width: double.infinity,
              height: h * 0.32,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: w * 0.62,
                    height: w * 0.62,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColor.primary.withOpacity(0.12),
                        width: 1.5,
                      ),
                    ),
                  ),
                  Container(
                    width: w * 0.46,
                    height: w * 0.46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColor.primary.withOpacity(0.20),
                        width: 1.5,
                      ),
                    ),
                  ),
                  Container(
                    width: w * 0.30,
                    height: w * 0.30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.primary.withOpacity(0.10),
                    ),
                  ),
                  Container(
                    width: w * 0.20,
                    height: w * 0.20,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.primary,
                    ),
                    child: Icon(
                      Icons.location_on_rounded,
                      color: AppColor.white,
                      size: w * 0.09,
                    ),
                  ),
                  Positioned(
                    top: h * 0.03,
                    left: w * 0.05,
                    child: _FloatingChip(label: "💻 Coding", color: const Color(0xFF0891B2)),
                  ),
                  Positioned(
                    top: h * 0.04,
                    right: w * 0.04,
                    child: _FloatingChip(label: "🎨 Design", color: const Color(0xFF7C3AED)),
                  ),
                  Positioned(
                    bottom: h * 0.03,
                    left: w * 0.04,
                    child: _FloatingChip(label: "🎵 Music", color: const Color(0xFFDC2626)),
                  ),
                  Positioned(
                    bottom: h * 0.02,
                    right: w * 0.05,
                    child: _FloatingChip(label: "🏋️ Fitness", color: AppColor.primary),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                child: Column(
                  spacing: h * 0.02,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: h * 0.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppCard(
                          padding: EdgeInsets.symmetric(
                            horizontal: w * 0.03,
                            vertical: w * 0.01,
                          ),
                          color: AppColor.primary.withOpacity(0.08),
                          margin: EdgeInsets.zero,
                          child: Text(
                            "Skills Community",
                            style: GoogleFonts.poppins(
                              fontSize: context.text10,
                              color: AppColor.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: h * 0.0),
                        Text(
                          "Share & Grow\nYour Skills Locally",
                          style: GoogleFonts.poppins(
                            fontSize: context.text20,
                            fontWeight: FontWeight.w600,
                            color: AppColor.title,
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: h * 0.01),
                        Text(
                          "Connect with people around you — teach what you know, learn what you don't.",
                          style: GoogleFonts.poppins(
                            fontSize: context.text14,
                            color: AppColor.subtitle,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),

                    Column(
                      spacing: h * 0.012,
                      children: [
                        _FeatureTile(
                          icon: Icons.groups_2_rounded,
                          title: "Find nearby skill sharers",
                          subtitle: "Discover people teaching around you",
                          color: const Color(0xFF0891B2),
                        ),
                        _FeatureTile(
                          icon: Icons.auto_awesome_rounded,
                          title: "Personalised for your area",
                          subtitle: "See trending skills in your city",
                          color: const Color(0xFF7C3AED),
                        ),
                        _FeatureTile(
                          icon: Icons.shield_outlined,
                          title: "Your privacy is safe",
                          subtitle: "Exact location is never shared",
                          color: AppColor.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.03),
              child: Column(
                children: [
                  AppButton(
                    isOutline: false,
                    text: "Allow Location Access",
                    isLoading: _locationController.isLoading.value,
                    onPressed: () async {
                      if (_locationController.isLoading.value) return;

                      await _locationController.requestLocationPermission();

                      if (_locationController.tempLat.value != 0.0 &&
                          _locationController.tempLng.value != 0.0) {

                        await _locationController.confirmLocation();

                        Get.offAllNamed('/spot-picker');
                      } else {
                        FlutterToast.error("Please allow location to continue");
                      }
                    },
                  ),
                  SizedBox(height: h * 0.012),
                  AppButton(
                    isOutline: true,
                    text: "Skip for now",
                    onPressed: () => Get.offAllNamed('/dashboard'),
                  ),
                  SizedBox(height: h * 0.02),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}

class _FloatingChip extends StatelessWidget {
  final String label;
  final Color color;
  const _FloatingChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.sWidth * 0.03,
        vertical: context.sWidth * 0.015,
      ),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.20), width: 1),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: context.text12,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final w = context.sWidth;
    return Row(
      children: [
        Container(
          width: w * 0.11,
          height: w * 0.11,
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: w * 0.055),
        ),
        SizedBox(width: w * 0.04),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: context.text14,
                fontWeight: FontWeight.w600,
                color: AppColor.title,
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: context.text12,
                color: AppColor.subtitle,
              ),
            ),
          ],
        ),
      ],
    );
  }
}