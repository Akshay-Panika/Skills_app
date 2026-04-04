import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:skills_app/core/constant/app_size.dart';

import '../../../core/constant/app_color.dart';
import '../../service/controller/service_list_controller.dart';
import '../../service/model/service_list_model.dart';
import '../../service/screen/service_details_screen.dart';

class ServiceCard extends StatelessWidget {
  final ServiceListModel service;
  final String serviceDistance;
  const ServiceCard({super.key, required this.service,required this.serviceDistance, });

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ServiceDetailsScreen(
            services: Get.find<ServiceListController>().services,
            serviceId: service.id.toString(),
            distanceText: serviceDistance,
          ),
        ),
      ),
      child: Container(
        width: context.sWidth*0.46,
        decoration: BoxDecoration(
          color: AppColor.white,
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
                  child: service.serviceImage.isNotEmpty
                      ? ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(14)),
                    child: Image.network(
                      service.serviceImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (c, e, st) => const Center(
                          child: Icon(Icons.image_not_supported_outlined,
                              color: Colors.grey)),
                    ),
                  )
                      : Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(14)),
                    ),
                    child: const Center(
                        child: Icon(Icons.image_not_supported_outlined,
                            color: Colors.grey)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    spacing: 6,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(service.serviceName, style:  TextStyle(fontSize: context.text12,fontWeight: FontWeight.w600, color: AppColor.title)),
                          Text(service.serviceDescription, style:  TextStyle(fontSize: context.text12, color: AppColor.subtitle)),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(service.serviceAmount != null ? "₹${service.serviceAmount}" : "Free", style:  TextStyle(fontWeight: FontWeight.w600,fontSize: context.text12)),
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
