import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skills_app/core/constant/app_color.dart';
import 'package:skills_app/core/widget/my_appbar.dart';
import '../../../core/constant/app_size.dart';
import '../../location/controller/location_controller.dart';
import '../../service/screen/service_details_screen.dart';
import '../controller/wishlist_controller.dart';
import '../controller/wishlist_remove_controller.dart';
import '../model/wishlist_model.dart';

class WishlistScreen extends StatelessWidget {
  WishlistScreen({super.key});

  final _getLocationController = Get.find<LocationController>();
  final wishlistController = Get.find<WishlistController>();
  final removerWishlistController = Get.find<WishlistRemoveController>();

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
        if (wishlistController.isLoading.value) {
          return  Center(child: CircularProgressIndicator(color: AppColor.primary,));
        }

        if (wishlistController.services.isEmpty) {
          return _EmptyState();
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
            final item = wishlistController.services[index];
            final distance = getDistanceText(
              lat,
              lon,
              item.latitude!,
              item.longitude!,
            );

            return _ServiceCard(
              service: item,
              onRemove: () async {
                await removerWishlistController.removeFromFavorite(
                  userId: 1,
                  serviceId: item.id,
                );

                wishlistController.services.removeWhere(
                      (e) => e.id == item.id,
                );
              }, serviceDistance: distance,
            );
          },
          itemCount: wishlistController.services.length,
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
                child:  CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.bookmark,
                    color: AppColor.primary,
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


class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [
          FaIcon(FontAwesomeIcons.bookmark,
              size: context.sWidth*0.14, color: AppColor.primary),
          SizedBox(height: 10),
          Text("Your wishlist is empty",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
          Text("Start adding services you love",style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: context.text12,color: Colors.grey)),
        ],
      ),
    );
  }
}