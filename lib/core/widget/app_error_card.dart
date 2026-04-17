import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constant/app_color.dart';
import '../constant/app_size.dart';
import 'app_card.dart';

class AppErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final VoidCallback? onCancel;
  final String? title;

  const AppErrorCard({
    super.key,
    required this.message,
    required this.onRetry,
    this.onCancel,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppCard(
        color: Colors.transparent,
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon( Icons.wifi_off_rounded,
                size: context.sWidth*0.14, color: AppColor.primary),
            SizedBox(height: 10),
            Text(title ?? "Network error",
                style: GoogleFonts.poppins(fontSize: context.text14,fontWeight: FontWeight.w500)),
            // Text(message ?? "Start booking services to chat"),
            SizedBox(height: 10),
            InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: onRetry,
              child: Chip(
                backgroundColor: AppColor.primary.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                avatar: Icon(
                  Icons.refresh,
                  size: 16,
                  color: AppColor.primary,
                ),
                label: Text(
                  "Refresh",
                  style: GoogleFonts.poppins(
                    color: AppColor.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              ),
            )
          ],
        ),
      ),
    );
  }
}