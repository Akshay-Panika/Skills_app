import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skills_app/core/constant/app_color.dart';
import 'package:skills_app/features/service/controller/service_list_controller.dart';
import '../../../core/widget/my_appbar.dart';
import '../../home/screen/home_screen.dart';
import '../../home/widget/service_card.dart';
import '../../location/widget/location_card.dart';


class ServiceScreen extends StatefulWidget {
  final String subcategoryId;
  const ServiceScreen({super.key, required this.subcategoryId});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final  _serviceListController = Get.find<ServiceListController>();
  bool _isFree = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: myAppBar(
        title: "Near by Skill",
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


        final filteredServices = _serviceListController.services.where((service) {
          final matchesSubcategory =
              service.subcategory?.toString() == widget.subcategoryId;

          final matchesFree =
          _isFree ? service.serviceStatus == false : true;

          return matchesSubcategory && matchesFree;
        }).toList();


        if (filteredServices.isEmpty) {
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
          itemCount: filteredServices.length,
          itemBuilder: (context, index) {
            final service = filteredServices[index];

            return ServiceCard(
              service: service,
            );
          },
        );
      }),
    );
  }
}
