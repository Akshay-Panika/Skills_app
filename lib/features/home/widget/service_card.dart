import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:skills_app/core/constant/app_size.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../../core/constant/app_color.dart';
import '../../service/model/service_list_model.dart';
import '../../service/screen/service_details_screen.dart';

class ServiceCard extends StatelessWidget {
  final ServiceListModel service;
  final String serviceDistance;
  const ServiceCard({super.key, required this.service,required this.serviceDistance, });

  @override
  Widget build(BuildContext context) {

    return InkWell(
      // onTap: () => Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => ServiceDetailsScreen(
      //       serviceId: service.id.toString(),
      //     ),
      //   ),
      // ),
      onTap: () {
        Get.toNamed('/service-details', parameters: {
          'id': service.id.toString(),
        });
      },
      child: Container(
        width: context.sWidth*0.48,
        decoration: BoxDecoration(
          color: AppColor.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade100, width: .5),
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                    child: CachedNetworkImage(
                      imageUrl: service.serviceImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[100],
                        alignment: Alignment.center,
                        child: FaIcon(
                          FontAwesomeIcons.chalkboardTeacher,
                          color: Colors.grey[400],
                          size: 40,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image_outlined, color: Colors.grey, size: 40),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    spacing: 6,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(service.serviceName, style:  TextStyle(fontSize: context.text12,fontWeight: FontWeight.w600, color: AppColor.title)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              service.serviceAmount != null
                                  ? "₹${double.tryParse(service.serviceAmount!)?.toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), '') ?? service.serviceAmount!}"
                                  : "Free",
                              style:  TextStyle(fontWeight: FontWeight.w600,fontSize: context.text12)),
                          Row(
                            children:  [
                              Icon(Icons.location_on, size: 12, color: Colors.green),
                              Text("$serviceDistance", style: TextStyle(fontSize: context.text12, color: Colors.black87),),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              top: 5,right: 5,
              child: CircleAvatar(
                radius: 14,
                backgroundColor: Colors.white,
                child: FaIcon(FontAwesomeIcons.bookmark,size: 14,color: Colors.grey,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
