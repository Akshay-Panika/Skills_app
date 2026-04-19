import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skills_app/core/constant/app_color.dart';
import 'package:skills_app/core/constant/app_size.dart';
import 'package:skills_app/core/widget/app_card.dart';

import '../screen/location_permission_screen.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Padding(
        padding:  EdgeInsets.symmetric(vertical: context.sWidth*0.02, horizontal: context.sWidth*0.02),
        child: Column(
          children: [
            /// Icon
            Container(
              height: context.sWidth*0.16,
              width: context.sWidth*0.16,
              decoration: BoxDecoration(
                color: AppColor.primary.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child:  Icon(
                Icons.location_off,
                size: context.sWidth*0.1,
                color:AppColor.success,
              ),
            ),

             SizedBox(height: context.sWidth*0.03),

            /// Title
             Text(
              "Enable Location",
              style: GoogleFonts.poppins(
                fontSize: context.text14,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),

            SizedBox(height: context.sWidth*0.01),

            /// Subtitle
            Text(
              "Please allow location access to find nearby people\nfor teaching and learning skills.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: context.text12,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            ),

            SizedBox(height: context.sWidth*0.06),

            /// Button
            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10,),
             color: AppColor.primary,
              child:  Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.my_location,
                    color: Colors.white,
                    size: context.sWidth*0.04,
                  ),
                  SizedBox(width: context.sWidth*0.02),
                  Text(
                    "Allow Location",
                    style: GoogleFonts.poppins(
                      fontSize: context.text12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              onTap: () {
                Get.to(
                      () => LocationPermissionScreen(),
                );
              },
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
class EmptyServiceWidget extends StatelessWidget {
  const EmptyServiceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Padding(
        padding:  EdgeInsets.symmetric(vertical: context.sWidth*0.02, horizontal: context.sWidth*0.02),
        child: Column(
          children: [
            /// Icon
            Container(
              height: context.sWidth*0.16,
              width: context.sWidth*0.16,
              decoration: BoxDecoration(
                color: AppColor.primary.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child:  Icon(
                Icons.location_off,
                size: context.sWidth*0.1,
                color:AppColor.success,
              ),
            ),

             SizedBox(height: context.sWidth*0.03),

            /// Title
             Text(
              "No Services Nearby",
              style: GoogleFonts.poppins(
                fontSize: context.text14,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),

            SizedBox(height: context.sWidth*0.01),

            /// Subtitle
            Text(
              "We couldn’t find any services within 20 km.\nTry changing location or check later.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: context.text12,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            ),

            SizedBox(height: context.sWidth*0.06),


            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

