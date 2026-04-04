import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constant/app_color.dart';
import '../../../core/constant/app_size.dart';

class InviteFriendCard extends StatelessWidget {
  const InviteFriendCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.circular(16),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.card_giftcard,
                  color: Colors.white,
                ),
              ),

              const SizedBox(width: 12),

              /// text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Invite Friends",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColor.white,
                      fontSize: context.text14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Earn rewards by sharing",
                    style: TextStyle(
                      color: AppColor.white,
                      fontSize: context.text14,
                    ),
                  ),
                ],
              ),
            ],
          ),

          InkWell(
            onTap: () {
              final textToShare =
                  "Check out this skill:";
              Share.share(textToShare);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child:  Text(
                "Share",
                style: TextStyle(
                  fontSize: context.text12,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
}
