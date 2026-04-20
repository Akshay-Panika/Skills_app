import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skills_app/core/constant/app_color.dart';
import 'package:skills_app/core/constant/app_size.dart';
import 'app_button.dart';

class AppDialog {
  /// Simple reusable dialog
  static Future<bool> show(
      BuildContext context, {
        required String title,
        required String message,
        String cancelText = "Cancel",
        String confirmText = "Ok",
      }) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: AppColor.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style:  GoogleFonts.poppins(fontSize: context.text16, fontWeight: FontWeight.w600, color: AppColor.title)),
              SizedBox(height: context.sHeight*0.01,),

              Text(message,style: GoogleFonts.poppins(color: AppColor.subtitle,fontSize: context.text14),),

              SizedBox(height: context.sHeight*0.03,),

              Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: AppButton(
                      text: cancelText,
                      isOutline: true,
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  ),

                  Expanded(
                    child: AppButton(
                      text: confirmText,
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ) ??
        false;
  }

  static Future<String?> showWithInput(
      BuildContext context, {
        required String title,
        String hintText = "Enter message...",
        String cancelText = "Cancel",
        String confirmText = "Ok",
      }) async {
    final TextEditingController controller = TextEditingController();

    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: AppColor.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: context.text16,
                  fontWeight: FontWeight.w600,
                  color: AppColor.title,
                ),
              ),

              SizedBox(height: context.sHeight * 0.01),

              /// 🔥 INPUT FIELD (replaces message text)
              TextField(
                controller: controller,
                maxLines: 4,
                minLines: 3,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: GoogleFonts.poppins(
                    color: AppColor.subtitle,
                    fontSize: context.text14,
                  ),
                  filled: true,
                  fillColor: AppColor.surface,
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColor.primary.withOpacity(0.2),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColor.primary.withOpacity(0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColor.primary),
                  ),
                ),
              ),

              SizedBox(height: context.sHeight * 0.03),

              Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: AppButton(
                      text: cancelText,
                      isOutline: true,
                      onPressed: () => Navigator.of(context).pop(null),
                    ),
                  ),

                  Expanded(
                    child: AppButton(
                      text: confirmText,
                      onPressed: () {
                        Navigator.of(context).pop(controller.text);
                      },
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