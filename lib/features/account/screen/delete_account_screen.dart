import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constant/app_color.dart';
import '../../../core/constant/app_size.dart';
import '../../../core/widget/app_button.dart';
import '../../../core/widget/app_dilog.dart';
import '../../../core/widget/my_appbar.dart';
import '../../../core/widget/flutter_toast.dart';
import '../../auth/screen/auth_screen.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  Future<void> _deleteAccount(BuildContext context) async {
    final bool confirmed = await AppDialog.show(
      context,
      title: "Delete Account?",
      message:
      "Are you sure you want to delete your account? This action is irreversible and all your data including courses, progress, and certificates will be lost.",
      cancelText: "Cancel",
      confirmText: "Delete",
    );

    if (confirmed) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // clear local data if needed

      FlutterToast.success("Account deleted successfully");
      Get.offAll(() => AuthScreen()); // navigate to login screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surface,
      appBar: myAppBar(
        title: "Delete Account",
        showBackButton: true,
        backgroundColor: AppColor.primary,
        titleColor: AppColor.white,
        buttonColor: AppColor.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: context.sHeight * 0.05),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.delete_forever,
                    size: context.sWidth * 0.25,
                    color: AppColor.error,
                  ),
                  SizedBox(height: context.sHeight * 0.03),
                  Text(
                    "Are you sure you want to delete your account?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: context.text16 + 2,
                      fontWeight: FontWeight.bold,
                      color: AppColor.title,
                    ),
                  ),
                  SizedBox(height: context.sHeight * 0.015),
                  Text(
                    "This action is irreversible and all your data including courses, progress, and certificates will be lost.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: context.text14,
                      color: AppColor.subtitle,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: context.sHeight * 0.04),
                  AppButton(
                    text: "Delete Account",
                    onPressed: () => _deleteAccount(context),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.sHeight * 0.05),
            Text(
              "Tip: You can also deactivate your account temporarily if you want to take a break from learning.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: context.text14,
                color: AppColor.subtitle,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}