import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skills_app/features/service/controller/service_list_controller.dart';
import 'package:skills_app/features/service/screen/service_details_screen.dart';
import '../../home/screen/home_screen.dart';
import '../../location/controller/location_controller.dart';
import '../model/service_list_model.dart';
import '../repository/service_list_repository.dart';

class ServiceScreen extends StatefulWidget {
  final String subcategoryId;
  final bool isPaid; // add paid/unpaid filter
  const ServiceScreen({super.key, required this.subcategoryId, this.isPaid = false});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final LocationController _getLocationController = Get.find<LocationController>();
  final ServiceListController _serviceListController = Get.put(ServiceListController(ServiceListRepository()),);
  bool  _isPaid = false;

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
        actions: [
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: _isPaid,

              /// 👇 ₹ ICON BOTH STATES
              thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
                    (states) {
                  if (states.contains(MaterialState.selected)) {
                    /// ON → PAID (Bold ₹)
                    return const Icon(
                      Icons.currency_rupee,
                      size: 16,
                      color: Colors.white,
                    );
                  }

                  /// OFF → UNPAID (Outlined ₹)
                  return const Icon(
                    Icons.currency_rupee_outlined,
                    size: 16,
                    color: Colors.white,
                  );
                },
              ),

              activeThumbColor: Colors.green,
              activeTrackColor: Colors.green.withOpacity(0.4),
              inactiveTrackColor: Colors.grey.shade200,
              inactiveThumbColor: Colors.grey,

              trackOutlineColor: MaterialStateProperty.all(
                Colors.grey.withOpacity(0.2),
              ),

              onChanged: (value) {
                setState(() {
                  _isPaid = value;
                });
              },
            ),
          )
        ],
      ),
      body:Obx(() {
        final lat = _getLocationController.latitude.value;
        final lon = _getLocationController.longitude.value;

        if (_serviceListController.isLoading.value || !_getLocationController.isLocationLoaded.value) {
          return _buildServiceShimmer();
        }

        if (lat == 0.0 || lon == 0.0) {return _buildServiceShimmer();}

        final filteredServices = _serviceListController.services.where((service) {
          bool matchSubcategory =
              service.subcategory?.toString() == widget.subcategoryId;

          bool matchPaid = _isPaid ? service.serviceStatus == true : true;

          return matchSubcategory && matchPaid;
        }).toList();

        final nearbyServices = filteredServices.where((service) {
          if (service.latitude == null || service.longitude == null) return false;

          double distanceKm = Geolocator.distanceBetween(
            lat,
            lon,
            service.latitude!,
            service.longitude!,
          ) / 1000;

          return distanceKm <= 20;
        }).toList();

        if (nearbyServices.isEmpty) {
          debugPrint("No services Near You");
          return Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Center(child: EmptyServiceWidget()),
          );
        }

        return GridView.builder(
          itemCount: filteredServices.length,
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            mainAxisExtent: 200,
          ),
          itemBuilder: (context, index) {
            final service = nearbyServices[index];

            double distanceKm = Geolocator.distanceBetween(
              lat,
              lon,
              service.latitude!,
              service.longitude!,
            ) / 1000;

            String distanceText;

            if (distanceKm < 1) {
              distanceText = "${(distanceKm * 1000).round()} m";
            } else {
              distanceText = "${distanceKm.toStringAsFixed(2)} km"; // more stable
            }

            return ServiceCard(
              service: service,
              serviceDistance: distanceText,
            );
          },
        );
      }),
    );
  }
}

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
        width: 260,
        decoration: BoxDecoration(
          color: Colors.white,
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
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name + Description
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(service.serviceName,
                                style: const TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(service.serviceDescription,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                      // Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                              service.serviceAmount != null
                                  ? "₹${service.serviceAmount}"
                                  : "Free",
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Row(
                            children:  [
                              Icon(Icons.location_on,
                                  size: 12, color: Colors.green),
                              Text(
                                "$serviceDistance",
                                style: TextStyle(fontSize: 12, color: Colors.grey),
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
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.bookmark_border, color: Colors.blueAccent)),
          ],
        ),
      ),
    );
  }
}

Widget _buildServiceShimmer() {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// Title
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            height: 14,
            width: 150,
            color: Colors.white,
          ),
        ),

        SizedBox(height: 10),

        /// Horizontal cards
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  width: 260,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// image
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12)),
                        ),
                      ),

                      SizedBox(height: 8),

                      /// title
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Container(
                          height: 12,
                          width: 100,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(height: 6),

                      /// subtitle
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Container(
                          height: 10,
                          width: 70,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(height: 10),

                      /// button / price
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Container(
                          height: 12,
                          width: 50,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}
