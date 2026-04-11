import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:skills_app/core/constant/app_color.dart';
import 'package:skills_app/core/widget/app_card.dart';
import 'package:skills_app/core/widget/my_appbar.dart';
import '../../../core/constant/app_size.dart';
import '../../location/controller/location_controller.dart';
import '../../service/model/service_list_model.dart';
import '../../service/screen/service_details_screen.dart';
import '../controller/wishlist_controller.dart';
import '../controller/wishlist_remove_controller.dart';
import '../controller/wishlist_toggle_controller.dart';
import '../model/wishlist_model.dart';

class WishlistScreen extends StatelessWidget {
  WishlistScreen({super.key});
  final LocationController _getLocationController = Get.find<LocationController>();

  final WishlistRemoveController removeController = Get.put(WishlistRemoveController());
  final WishlistController controller = Get.put(WishlistController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surface,
      appBar: myAppBar(
        title: "Wishlist",
        centerTitle: true,
        showBackButton: true,
        backgroundColor: AppColor.primary,
        titleColor: AppColor.white,
        buttonColor: AppColor.white
      ),
      body: Obx(() {
        final lat = _getLocationController.latitude.value;
        final lon = _getLocationController.longitude.value;
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.services.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bookmark_remove_outlined,
                  size: 70,
                  color: Colors.grey,
                ),
                SizedBox(height: 12),
                Text(
                  "Your wishlist is empty",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Start adding services you love",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }
        return  GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8,
            // crossAxisCount: nearbyServices.length,
          ),
          itemBuilder: (context, index) {
            final item = controller.services[index];
            final distance = getDistanceText(
              lat,
              lon,
              item.latitude!,
              item.longitude!,
            );

            return _ServiceCard(
              service: item,
              onRemove: () async {
                await removeController.removeFromFavorite(
                  userId: 1,
                  serviceId: item.id,
                );

                controller.services.removeWhere(
                      (e) => e.id == item.id,
                );
              }, serviceDistance: distance,
            );
          },
          itemCount: controller.services.length,
        );
      }),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final WishlistModel  service;
  final String serviceDistance;
  final VoidCallback onRemove;

  const _ServiceCard({
    super.key,
    required this.service,
    required this.serviceDistance,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {

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
              top: -2,
              right: -2,
              child: InkWell(
                onTap: onRemove,
                child: const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.bookmark,
                    color: Colors.red,
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
