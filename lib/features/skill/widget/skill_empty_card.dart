import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
              size: context.sWidth * 0.12,
              color: AppColor.primary.withOpacity(0.4),
            ),

            SizedBox(height: context.sHeight * 0.025),

            Text(
              "Share Your Skills",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: context.text16,
                fontWeight: FontWeight.w700,
                color: AppColor.title,
              ),
            ),

            SizedBox(height: 8),

            Text(
              "Start posting your skills and connect with people",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: context.text12,
                color: AppColor.subtitle,
                height: 1.4,
              ),
            ),

            SizedBox(height: context.sHeight * 0.03),

          ],
        ),
      ),
    );
  }
}