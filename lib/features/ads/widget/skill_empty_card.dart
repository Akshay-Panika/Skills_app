import 'package:flutter/cupertino.dart';

import '../../../core/constant/app_color.dart';
import '../../../core/constant/app_size.dart';

class SkillEmptyCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const SkillEmptyCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: context.sHeight * 0.1,
            height: context.sHeight * 0.1,
            decoration:  BoxDecoration(
              color: AppColor.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 44, color: AppColor.primary),
          ),
          SizedBox(height: context.sHeight*0.02,),
          Text(title,
              style: TextStyle(
                  fontSize: context.text16,
                  fontWeight: FontWeight.w800,
                  color: AppColor.title)),
          Text(subtitle,
              style:
              TextStyle(fontSize: context.text14, color: AppColor.subtitle)),
        ],
      ),
    );
  }
}