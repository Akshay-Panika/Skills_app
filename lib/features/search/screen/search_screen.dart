import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:skills_app/core/constant/app_color.dart';
import 'package:skills_app/core/constant/app_size.dart';
import 'package:skills_app/core/widget/app_card.dart';

import '../../category/controller/category_controller.dart';
import '../../home/screen/home_screen.dart';
import '../../home/widget/category_card.dart';
import '../../home/widget/service_card.dart';
import '../../location/controller/location_controller.dart';
import '../../service/controller/service_list_controller.dart';
import '../../service/repository/service_list_repository.dart';
import '../../service/screen/service_details_screen.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});
  final LocationController _locationController = Get.put(LocationController());
  final LocationController _getLocationController = Get.find<LocationController>();

  final CategoryController _categoryController = Get.put(CategoryController());
  final ServiceListController _serviceListController = Get.put(ServiceListController(ServiceListRepository()));


  final List<String> recentSearches = const [
    'Python for beginners',
    'UI UX design',
    'Digital Marketing',
    'Data Science',
    'Flutter development',
  ];


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
                  SizedBox(height: context.sHeight * 0.02),
                  _buildRecentSearches(context),

                  /// default data
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: context.sHeight * 0.02),
                      Obx(() {
                        final lat = _getLocationController.latitude.value;
                        final lon = _getLocationController.longitude.value;
                        final services = _serviceListController.services;

                        final nearby = services.where((s) {
                          if (s.latitude == null || s.longitude == null) return false;

                          final distance = Geolocator.distanceBetween(
                            lat,
                            lon,
                            s.latitude!,
                            s.longitude!,
                          ) / 1000;

                          // final matchesFree = _isFree ? s.serviceStatus == false : true;

                          return distance <= 20;
                        }).toList();

                        if (nearby.isEmpty) {
                          debugPrint("No services Near You");
                          return SizedBox.shrink();
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _sectionTitle("Resent View", context),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Based on your learning interests',
                                    style: TextStyle(
                                        fontSize: context.text12,
                                        color: AppColor.title),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),

                            GridView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(horizontal: 10,),
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 0.8,
                                // crossAxisCount: nearbyServices.length,
                              ),
                              itemBuilder: (context, index) {
                                final service = nearby[index];
                                final distance = getDistanceText(
                                  lat,
                                  lon,
                                  service.latitude!,
                                  service.longitude!,
                                );

                                return Container(
                                  height: 200,
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: ServiceCard(
                                    service: service,
                                    serviceDistance: distance,
                                  ),
                                );
                              },
                              itemCount: nearby.length,
                            ),

                          ],
                        );
                      }),
                      _buildCategories(context),
                      SizedBox(height: context.sHeight * 0.03),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, BuildContext context) {
    return Row(
      children: [
        Container(
          width: 5,
          height: 16,
          decoration: BoxDecoration(
            color: AppColor.primary,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: context.text14,
            fontWeight: FontWeight.w600,
            color: AppColor.title,
          ),
        ),
      ],
    );
  }

  // 🔹 HEADER
  Widget _buildHeader(BuildContext context) {
    return Container(
      color: AppColor.primary,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 14,
        left: 12,
        right: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.menu_book_rounded,
                  color: AppColor.white),
              const SizedBox(width: 8),
              Text(
                'SkillHub',
                style: TextStyle(
                  color: AppColor.white,
                  fontSize: context.text16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: context.sHeight * 0.01),

          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back,
                    color: AppColor.white),
              ),
              Expanded(
                child: Container(
                  height: context.sHeight * 0.05,
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      const FaIcon(FontAwesomeIcons.search,
                          color: AppColor.subtitle, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                              fontSize: context.text12,
                              color: AppColor.subtitle),
                          decoration: InputDecoration(
                            hintText:
                            'Find Courses, Skills, Tutors...',
                            hintStyle: TextStyle(
                                fontSize: context.text12,
                                color: AppColor.subtitle),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const Icon(Icons.mic,
                          color: AppColor.subtitle),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildLocationBar(BuildContext context) {
    return Container(

      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.primary, width: 0.3),
        borderRadius: BorderRadius.circular(6),
        color: AppColor.primary,
      ),
      child: Obx(() {
        // Show spinner while loading
        final isLoading = !_locationController.isLocationLoaded.value;

        final locationText = isLoading
            ? 'Fetching location...'
            : '${_locationController.city.value}, ${_locationController.state.value}';

        return Row(
          children: [
            const Icon(Icons.location_on, color: AppColor.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                locationText,
                style: TextStyle(
                  fontSize: context.text12,
                  color: AppColor.white,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                  onTap:() => _locationController.fetchLocation(),
                  child: isLoading ?
                  SizedBox(
                      height: 22,width: 22,
                      child: CircularProgressIndicator(color: Colors.white,strokeWidth: 3,))
                  :FaIcon(FontAwesomeIcons.refresh, color: Colors.white, size: 22,)),
            ),

          ],
        );
      }),
    );
  }
  // 🔹 RECENT SEARCHES
  Widget _buildRecentSearches(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _sectionTitle("Recent Searches", context),
              Text(
                "Clear all",
                style: TextStyle(
                  fontSize: context.text12,
                  color: AppColor.primary,
                ),
              )
            ],
          ),
          SizedBox(height: context.sHeight * 0.015),
          Wrap(
            spacing: 3,
            runSpacing: 6,
            children:
            recentSearches.map(_buildTag).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return AppCard(
      color: AppColor.primary.withOpacity(.1),
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.history,
              size: 14, color: AppColor.subtitle),
          const SizedBox(width: 6),
          Text(label,
              style:
               TextStyle(color: AppColor.title,fontSize: 12)),
        ],
      ),
    );
  }

  // 🔹 CATEGORIES
  Widget _buildCategories(BuildContext context) {
    return Obx(() {
      if (_categoryController.isLoading.value) {
        return const SizedBox();
      }
      if (_categoryController.categoryList.isEmpty) {
        debugPrint("No services Near You");
        return SizedBox.shrink();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16),
            child: _sectionTitle("Popular Skills", context),
          ),
          SizedBox(height: context.sHeight * 0.02),
          SizedBox(
            height: context.sHeight * 0.25,
            child: GridView.builder(
              padding:
              const EdgeInsets.symmetric(horizontal: 10),
              scrollDirection: Axis.horizontal,
              itemCount:
              _categoryController.categoryList.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                mainAxisExtent: 65,
              ),
              itemBuilder: (context, index) {
                final category =
                _categoryController.categoryList[index];
                return CategoryCard(category: category);
              },
            ),
          ),
        ],
      );
    });
  }
}