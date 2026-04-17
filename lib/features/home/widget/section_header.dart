import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

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
          /// LEFT SIDE
          Row(
            children: [
              Container(
                width: 5,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D6E6E),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
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
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                const FaIcon(
                  FontAwesomeIcons.arrowRightLong,
                  size: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}