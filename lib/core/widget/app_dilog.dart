import 'package:flutter/material.dart';
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
              Text(title, style:  TextStyle(fontSize: context.text18, fontWeight: FontWeight.bold, color: AppColor.title)),
              SizedBox(height: context.sHeight*0.01,),

              Text(message,style: TextStyle(color: AppColor.subtitle,fontSize: context.text14),),

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
}