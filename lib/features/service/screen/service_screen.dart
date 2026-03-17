import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skills_app/features/service/controller/service_list_controller.dart';
import 'package:skills_app/features/service/screen/service_details_screen.dart';

import '../repository/service_list_repository.dart';

class ServiceScreen extends StatelessWidget {
  final String subcategoryId;
  ServiceScreen({super.key, required this.subcategoryId});

  // Initialize controller
  final ServiceListController controller = Get.put(
    ServiceListController(ServiceListRepository()),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        title: const Text("Service"),
        titleTextStyle: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final filteredServices = controller.services
            .where((s) => s.subcategory.toString() == subcategoryId)
            .toList();

        if (filteredServices.isEmpty) {
          return const Center(child: Text("No services available"));
        }

        return GridView.builder(
          itemCount: filteredServices.length,
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            mainAxisExtent: 200,
          ),
          itemBuilder: (context, index) {
            final service = filteredServices[index];
            return InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServiceDetailsScreen(
                    services: filteredServices,
                    serviceId: service.id.toString(),),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.grey.shade100,
                    width: 0.5,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Service Image
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(14),
                              ),
                              image: service.serviceImage.isNotEmpty
                                  ? DecorationImage(
                                image: NetworkImage(service.serviceImage),
                                fit: BoxFit.cover,
                              )
                                  : null,
                            ),
                            child: service.serviceImage.isEmpty
                                ? const Center(
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                color: Colors.white,
                                size: 40,
                              ),
                            )
                                : null,
                          ),
                        ),

                        // Service Name, Description & Price
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Name + Description
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    service.serviceName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    service.serviceDescription,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),

                              // Price & Distance (if available)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    service.serviceAmount != null
                                        ? "₹${service.serviceAmount}"
                                        : "Free",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: const [
                                      Icon(
                                        Icons.location_on,
                                        size: 12,
                                        color: Colors.lightBlueAccent,
                                      ),
                                      Text(
                                        "5 km", // You can later replace with real distance
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Bookmark icon
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.bookmark_border,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}