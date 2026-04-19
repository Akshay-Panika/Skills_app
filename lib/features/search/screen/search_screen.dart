import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skills_app/core/constant/app_color.dart';
import 'package:skills_app/core/constant/app_size.dart';
import 'package:skills_app/core/widget/app_card.dart';
import '../../category/controller/category_controller.dart';
import '../../home/widget/category_card.dart';
import '../../home/widget/section_header.dart';
import '../../home/widget/service_card.dart';
import '../../location/controller/location_controller.dart';
import '../../service/controller/service_list_controller.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final _locationController = Get.find<LocationController>();
  final _categoryController = Get.find<CategoryController>();
  final _serviceListController = Get.find<ServiceListController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Column(
        children: [
          _buildHeader(context),
          SizedBox(height: context.sHeight * 0.01),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLocationBar(context),

                  Obx(() {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCategories(context),
                        SizedBox(height: context.sHeight * 0.02),
                        _buildNearbyDefaultSection(context),
                        SizedBox(height: context.sHeight * 0.03),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: AppColor.primary,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 14, left: 12, right: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(FontAwesomeIcons.chalkboardTeacher, color: AppColor.white, size: 18,),
              const SizedBox(width: 8),
              Text('Skill Daan', style: GoogleFonts.poppins(color: AppColor.white, fontSize: context.text14, fontWeight: FontWeight.w600)),
            ],
          ),
          SizedBox(height: context.sHeight * 0.01),
          Row(
            children: [
              IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back, color: AppColor.white)),
              Expanded(
                child: Container(
                  height: context.sHeight * 0.04,
                  decoration: BoxDecoration(color: AppColor.white, borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                       FaIcon(FontAwesomeIcons.search, color: Colors.grey, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          style: TextStyle(fontSize: context.text12, color: AppColor.subtitle),
                          decoration: InputDecoration(
                            hintText: 'Find Courses, Skills, Tutors...',
                            hintStyle: TextStyle(fontSize: context.text12, color: AppColor.subtitle),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      // Icon(Icons.mic, color: Colors.grey,),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildNearbyDefaultSection(BuildContext context) {
    final lat = _locationController.latitude.value;
    final lon = _locationController.longitude.value;
    final services = _serviceListController.services;

    final nearby = services.where((s) {
      if (s.latitude == null || s.longitude == null) return false;
      return (Geolocator.distanceBetween(lat, lon, s.latitude!, s.longitude!) / 1000) <= 20;
    }).toList();

    if (nearby.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: "Resent View",
              onTap: () {

              },
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Based on your learning interests',
                  style: TextStyle(fontSize: context.text12, color: AppColor.title)),
            ),
          ],
        ),
        SizedBox(height: context.sHeight * 0.014),

        GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.8),
          itemCount: nearby.length,
          itemBuilder: (context, index) {
            final service = nearby[index];
            return ServiceCard(
              service: service,
            );
          },
        ),
      ],
    );
  }

  Widget _buildLocationBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColor.primary,
          width: 0.3,
        ),
        borderRadius: BorderRadius.circular(6),
        color: AppColor.primary,
      ),
      child: Obx(() {
        final isLoading = _locationController.isLoading.value;

        final locationText = isLoading
            ? 'Fetching location...'
            : '${_locationController.city.value}, ${_locationController.state.value}';

        return Row(
          children: [
            const Icon(
              Icons.location_on,
              color: AppColor.white,
              size: 18,
            ),
            const SizedBox(width: 8),

            Expanded(
              child: Text(
                locationText,
                style: GoogleFonts.poppins(
                  fontSize: context.text12,
                  color: AppColor.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () async {
                  if (_locationController.isLoading.value) return;
                  await _locationController.requestLocationPermission();
                  await _serviceListController.fetchServiceList();
                },
                child: isLoading
                    ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
                    : const FaIcon(
                  FontAwesomeIcons.refresh,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
  Widget _buildCategories(BuildContext context) {
    return Obx(() {
      if (_categoryController.isLoading.value || _categoryController.categoryList.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.sHeight * 0.02),
          SectionHeader(
            title: "Popular Skills",
            onTap: () {

            },
          ),
          SizedBox(height: context.sHeight * 0.014),
          SizedBox(
            height: context.sHeight * 0.25,
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              scrollDirection: Axis.horizontal,
              itemCount: _categoryController.categoryList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 14, crossAxisSpacing: 14, mainAxisExtent: 65),
              itemBuilder: (context, index) => CategoryCard(category: _categoryController.categoryList[index]),
            ),
          ),
        ],
      );
    });
  }
}