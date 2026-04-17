import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skills_app/core/constant/app_size.dart';
import 'package:skills_app/features/wishlist/controller/wishlist_toggle_controller.dart';
import '../../../core/constant/app_color.dart';
import '../../service/controller/service_list_controller.dart';
import '../../service/model/service_list_model.dart';


class ServiceCard extends StatelessWidget {
  final ServiceListModel service;
  const ServiceCard({super.key, required this.service, });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WishlistToggleController>();

    return InkWell(
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
                      Text(service.serviceName, style:  GoogleFonts.poppins(fontSize: context.text12,fontWeight: FontWeight.w500, color: AppColor.title)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              service.serviceAmount != null
                                  ? "₹${double.tryParse(service.serviceAmount!)?.toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), '') ?? service.serviceAmount!}"
                                  : "Free",
                              style:  GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: context.text12)),
                          Row(
                            children:  [
                              Icon(Icons.location_on, size: 12, color: Colors.green),
                              Text(service.distance ?? "0 m", style: GoogleFonts.poppins(fontSize: context.text12, color: Colors.black87),),
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
              top: -2,
              right: -2,
              child: InkWell(
                onTap: () async {
                  await controller.toggleWishlist(serviceId: service.id);
                  Get.find<ServiceListController>()
                      .toggleLocalFavorite(service.id);
                },
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: Icon(
                    service.isFavorite
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color: service.isFavorite
                        ? AppColor.primary
                        : Colors.grey,
                    size: 25,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
