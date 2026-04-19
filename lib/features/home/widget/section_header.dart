import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constant/app_color.dart';
import '../../../core/constant/app_size.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback? onTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText = "See All",
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: context.width*0.02,
            children: [
              Container(
                width: context.width*0.01,
                height: context.width*0.03,
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),

              Text(title,
                style:  GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: context.text14,
                  color: AppColor.title,
                ),
              ),
            ],
          ),

          /// RIGHT SIDE (ACTION)
          InkWell(
            onTap: onTap,
            child: Row(
              children: [
                Text(
                  actionText,
                  style:  GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: context.text14,
                    color: AppColor.title,
                  ),
                ),
                const SizedBox(width: 6),
                 FaIcon(
                  FontAwesomeIcons.arrowRightLong,
                  size: context.sWidth*0.03,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}