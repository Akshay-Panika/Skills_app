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
  const ServiceScreen({super.key, required this.subcategoryId});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final LocationController _getLocationController = Get.find<LocationController>();
  final ServiceListController _serviceListController = Get.put(ServiceListController(ServiceListRepository()));
  bool _isFree = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: myAppBar(
        title: "Service",
        showBackButton: true,
        backgroundColor: AppColor.primary,
        titleColor: AppColor.white,
        buttonColor: AppColor.white,
        actions: [
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: _isFree,
              thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
                    (states) {
                  if (states.contains(MaterialState.selected)) {
                    return const Icon(Icons.currency_rupee, size: 16, color: Colors.white);
                  }
                  return const Icon(Icons.currency_rupee_outlined, size: 16, color: Colors.white);
                },
              ),
              activeThumbColor: Colors.green,
              activeTrackColor: Colors.green.withOpacity(0.4),
              inactiveTrackColor: Colors.grey.shade200,
              inactiveThumbColor: Colors.grey,
              trackOutlineColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.2)),
              onChanged: (value) {
                setState(() {
                  _isFree = value;
                });
              },
            ),
          )
        ],
      ),
      body: Obx(() {
        final lat = _getLocationController.latitude.value;
        final lon = _getLocationController.longitude.value;

        // Step 1: Filter by subcategory
        final filteredServices = _serviceListController.services.where((service) {
          return service.subcategory?.toString() == widget.subcategoryId;
        }).toList();

        // Step 2: Filter by distance & free/paid
        final nearby = filteredServices.where((service) {
          if (service.latitude == null || service.longitude == null) return false;

          final distanceKm = Geolocator.distanceBetween(
            lat,
            lon,
            service.latitude!,
            service.longitude!,
          ) / 1000;

          // ✅ Corrected _isFree logic
          final matchesFree = _isFree ? service.serviceStatus == false : true;

          return distanceKm <= 20 && matchesFree;
        }).toList();

        if (nearby.isEmpty) {
          return const Padding(
            padding: EdgeInsets.only(top: 200),
            child: Center(child: EmptyServiceWidget()),
          );
        }

        // Step 3: Show Grid
        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8,
          ),
          itemCount: nearby.length,
          itemBuilder: (context, index) {
            final service = nearby[index];
            final distanceText = getDistanceText(
              lat,
              lon,
              service.latitude!,
              service.longitude!,
            );

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
