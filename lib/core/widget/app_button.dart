import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constant/app_color.dart';
import '../constant/app_size.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutline;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutline = false,
  });

  @override
  Widget build(BuildContext context) {
    // Determine background color based on isLoading and isOutline
    Color backgroundColor;
    if (isLoading) {
      backgroundColor = AppColor.surface;
    } else {
      backgroundColor = isOutline ? AppColor.surface : AppColor.primary;
    }

    Color foregroundColor;
    if (isLoading) {
      foregroundColor = AppColor.title; // text color when loading
    } else {
      foregroundColor = isOutline ? AppColor.primary : AppColor.white;
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          side: isOutline && !isLoading ? BorderSide(color: AppColor.primary) : null,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
          height: 22,
          width: 22,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: AppColor.primary,
          ),
        )
            : Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: context.text14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}