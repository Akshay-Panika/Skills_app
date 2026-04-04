import 'package:flutter/material.dart';
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
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
          isOutline ? Colors.transparent : AppColor.primary,
          foregroundColor:
          isOutline ? AppColor.primary : AppColor.white,
          side: isOutline ? BorderSide(color: AppColor.primary) : null,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(height: 22, width: 22,
             child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white,),)
            : Text(text, style: TextStyle(fontSize: context.text14, fontWeight: FontWeight.bold,),),
      ),
    );
  }
}