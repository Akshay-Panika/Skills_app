import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constant/app_color.dart';
import '../../../core/constant/app_size.dart';

class SkillEmptyCard extends StatelessWidget {
  const SkillEmptyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.sWidth * 0.12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.chalkboardTeacher,
                size: context.sWidth*0.14, color: AppColor.primary),

            SizedBox(height: 10,),

            Text(
              "Share Your Skills",
              textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),

            SizedBox(height: 8),

            Text(
              "Start posting your skills and connect with people",
              textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: context.text12,color: Colors.grey)),

            SizedBox(height: context.sHeight * 0.03),

          ],
        ),
      ),
    );
  }
}