import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skills_app/core/constant/app_color.dart';
import 'package:skills_app/features/service/controller/service_list_controller.dart';
import 'package:skills_app/features/service/screen/service_details_screen.dart';
import '../../../core/widget/my_appbar.dart';
import '../../home/screen/home_screen.dart';
import '../../home/widget/service_card.dart';
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
      backgroundColor: AppColor.white,
      appBar: myAppBar(
        title: "Service",
        showBackButton: true,
        backgroundColor: AppColor.white,
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

        final filteredServices = _serviceListController.services.where((service) {
          bool matchSubcategory =
              service.subcategory?.toString() == widget.subcategoryId;

          bool matchPaid = _isPaid ? service.serviceStatus == true : true;

          return matchSubcategory && matchPaid;
        }).toList();

        final nearby = filteredServices.where((s) {
          if (s.latitude == null) return false;
          double d = Geolocator.distanceBetween(lat, lon, s.latitude!, s.longitude!) / 1000;
          bool matchesPaidFilter = _isPaid ? (s.serviceStatus == true) : true;
          return d <= 20 && matchesPaidFilter;
        }).toList();

        if (nearby.isEmpty) {
          debugPrint("No services Near You");
          return Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Center(child: EmptyServiceWidget()),
          );
        }

        return  GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75,
            // crossAxisCount: nearbyServices.length,
          ),
          itemBuilder: (context, index) {
            final service = nearby[index];

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

            return Container(
              height: 200,
              padding: EdgeInsets.only(bottom: 10),
              child: ServiceCard(
                service: service,
                serviceDistance: distanceText,
              ),
            );
          },
          itemCount: nearby.length,
        );
      }),
    );
  }
}

// class ServiceCard extends StatelessWidget {
//   final ServiceListModel service;
//   final String serviceDistance;
//   const ServiceCard({super.key, required this.service,required this.serviceDistance, });
//
//   @override
//   Widget build(BuildContext context) {
//
//     return InkWell(
//       onTap: () => Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ServiceDetailsScreen(
//             services: Get.find<ServiceListController>().services,
//             serviceId: service.id.toString(),
//             distanceText: serviceDistance,
//           ),
//         ),
//       ),
//       child: Container(
//         width: 260,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: Colors.grey.shade100, width: .5),
//         ),
//         child: Stack(
//           alignment: Alignment.topRight,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: service.serviceImage.isNotEmpty
//                       ? ClipRRect(
//                     borderRadius: const BorderRadius.vertical(
//                         top: Radius.circular(14)),
//                     child: Image.network(
//                       service.serviceImage,
//                       fit: BoxFit.cover,
//                       width: double.infinity,
//                       errorBuilder: (c, e, st) => const Center(
//                           child: Icon(Icons.image_not_supported_outlined,
//                               color: Colors.grey)),
//                     ),
//                   )
//                       : Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade100,
//                       borderRadius: const BorderRadius.vertical(
//                           top: Radius.circular(14)),
//                     ),
//                     child: const Center(
//                         child: Icon(Icons.image_not_supported_outlined,
//                             color: Colors.grey)),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Name + Description
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(service.serviceName,
//                                 style: const TextStyle(fontWeight: FontWeight.w600)),
//                             const SizedBox(height: 4),
//                             Text(service.serviceDescription,
//                                 style: const TextStyle(
//                                     fontSize: 12, color: Colors.grey)),
//                           ],
//                         ),
//                       ),
//                       // Price
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Text(
//                               service.serviceAmount != null
//                                   ? "₹${service.serviceAmount}"
//                                   : "Free",
//                               style: const TextStyle(fontWeight: FontWeight.bold)),
//                           const SizedBox(height: 4),
//                           Row(
//                             children:  [
//                               Icon(Icons.location_on,
//                                   size: 12, color: Colors.green),
//                               Text(
//                                 "$serviceDistance",
//                                 style: TextStyle(fontSize: 12, color: Colors.grey),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             IconButton(
//                 onPressed: () {},
//                 icon: const Icon(Icons.bookmark_border, color: Colors.blueAccent)),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
