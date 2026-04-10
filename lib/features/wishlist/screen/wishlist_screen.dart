import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skills_app/core/constant/app_color.dart';
import 'package:skills_app/core/widget/app_card.dart';
import 'package:skills_app/core/widget/my_appbar.dart';
import '../controller/wishlist_controller.dart';

class WishlistScreen extends StatelessWidget {
  WishlistScreen({super.key});

  final WishlistController controller = Get.put(WishlistController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surface,
      appBar: myAppBar(
        title: "Wishlist",
        centerTitle: true,
        showBackButton: true
      ),
      body: Obx(() {
        // 🔄 Loading
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // ❌ Empty state
        if (controller.services.isEmpty) {
          return const Center(
            child: Text("No wishlist items found"),
          );
        }

        // ✅ List data
        return ListView.builder(
          itemCount: controller.services.length,
         padding: EdgeInsets.symmetric(horizontal: 10),
          itemBuilder: (context, index) {
            final item = controller.services[index];

            return AppCard(
              hasBorder: true,
              margin: EdgeInsets.only(top: 10),
              onTap: () {
                Get.toNamed('/service-details', parameters: {
                  'id': item.id.toString(),
                });
              },
              child: Row(
                children: [
                  // 🖼️ Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      item.serviceImage,
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image_not_supported),
                    ),
                  ),

                  // 📄 Details
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🏷️ Name
                          Text(
                            item.serviceName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          // 💰 Price
                          Text(
                            item.serviceAmount != null
                                ? "₹ ${item.serviceAmount}"
                                : "Free",
                            style:  TextStyle(
                              color: AppColor.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 6),

                          // 📝 Description
                          Text(
                            item.serviceDescription,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13),
                          ),

                          const SizedBox(height: 8),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}