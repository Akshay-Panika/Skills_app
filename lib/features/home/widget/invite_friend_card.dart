import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skills_app/core/widget/app_card.dart';

import '../../../core/constant/app_color.dart';
import '../../../core/constant/app_size.dart';

class InviteFriendCard extends StatelessWidget {
  const InviteFriendCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin:  EdgeInsets.symmetric(horizontal: context.sWidth*0.03),
      padding:  EdgeInsets.all(context.sWidth*0.02),
      color: AppColor.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              AppCard(
                color: Colors.blueAccent.withOpacity(.15),
                padding: const EdgeInsets.all(10),
                child: const Icon(
                  Icons.card_giftcard,
                  color: Colors.white,
                ),
              ),

               SizedBox(width: context.sWidth*0.02),

              /// text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Invite Friends",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: AppColor.white,
                      fontSize: context.text14,
                    ),
                  ),
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
              final textToShare = '''
🚀 Skills Daan App – Apni Skills Share Karo, Seekho aur Earn Karo!

Main ab Skills Daan App use kar raha hoon jahan log apni skills (coding, design, cooking, teaching, etc.) share karte hain aur naye skills seekhte hain.

👨‍💻 Apni talent dikhao  
📚 Nayi skills seekho  
💰 Aur rewards bhi kamao  

Abhi join karo aur apni skills ko duniya tak pahunchao 👇  
👉 Download Now: https://your-app-link.com

#SkillsDaan #LearnAndEarn #SkillSharing
''';

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
                style: GoogleFonts.poppins(
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
