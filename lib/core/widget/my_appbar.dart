import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constant/app_color.dart';

PreferredSizeWidget myAppBar({
  required String title,
  List<Widget>? actions,
  bool centerTitle = true,
  bool showBackButton = false,
  Color backgroundColor = AppColor.white,
  Color titleColor = Colors.black,
  Color buttonColor = Colors.black,
  VoidCallback? onBackPressed,
  PreferredSizeWidget? bottom,

}) {
  return AppBar(
    automaticallyImplyLeading: false,
    leading: showBackButton
        ? IconButton(
      icon: Icon(Icons.arrow_back_ios, color: buttonColor),
      onPressed: () => Get.back(),
    )
        : null,
    title: Text(
      title,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: titleColor,
      ),
    ),
    centerTitle: centerTitle,
    backgroundColor: backgroundColor,
    surfaceTintColor: backgroundColor,
    scrolledUnderElevation: 0,
    shadowColor: Colors.transparent,
    actions: actions,
    bottom: bottom,
  );
}