import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/constant/app_color.dart';
import '../../../core/constant/app_size.dart';

class SkillEmptyCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const SkillEmptyCard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.sWidth * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Skills Share Icon
            FaIcon(
              FontAwesomeIcons.chalkboardTeacher,
              size: context.sWidth * 0.4,
              color: AppColor.primary,
            ),

            SizedBox(height: context.sHeight * 0.02),

            /// Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: context.text16,
                fontWeight: FontWeight.w600,
                color: AppColor.title,
              ),
            ),

            SizedBox(height: 6),

            /// Subtitle
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: context.text14,
                color: AppColor.subtitle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}