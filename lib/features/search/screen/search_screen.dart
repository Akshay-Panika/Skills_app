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


  final RxList<String> recentSearches = [
    'Python Developer',
    'UI UX design',
    'Data Science',
    'Flutter Developer',
    'Web Developer',
    'React Developer',
  ].obs;

  final TextEditingController _searchController = TextEditingController();
  final RxString _searchQuery = ''.obs;

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

                  _buildRecentSearches(context),

                  Obx(() {
                    if (_searchQuery.value.isNotEmpty) return const SizedBox.shrink();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: context.sHeight * 0.02),
                        _buildNearbyDefaultSection(context),
                        _buildCategories(context),
                        SizedBox(height: context.sHeight * 0.03),
                      ],
                    );
                  }),

                  // 3. SEARCH RESULT SECTION
                  _buildSearchResultSection(context),
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
                          controller: _searchController,
                          onSubmitted: (v) => _searchQuery.value = v.trim(),
                          onChanged: (v) {
                            if (v.isEmpty) _searchQuery.value = '';
                          },
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

  // --- RECENT SEARCHES ---
  Widget _buildRecentSearches(BuildContext context) {
    return Obx(() {
      if (_searchQuery.value.isNotEmpty || recentSearches.isEmpty) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.sHeight * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _sectionTitle("Recent Searches", context),
                InkWell(
                  onTap: () {
                    recentSearches.clear(); // List ko empty kar dega
                  },
                  child: Text(
                    "Clear all",
                    style: TextStyle(
                      fontSize: context.text12,
                      color: AppColor.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.sHeight * 0.015),
            Wrap(
              spacing: 4,
              runSpacing: 6,
              children: recentSearches.map((label) => _buildTag(label, context)).toList(),
            ),
          ],
        ),
      );
    });
  }
  Widget _buildTag(String label, BuildContext context) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
        _searchController.text = label;
        _searchQuery.value = label;
      },
      borderRadius: BorderRadius.circular(8),
      child: AppCard(
        color: AppColor.white,
        margin: EdgeInsets.zero,
        hasBorder: true,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.history, size: 14, color: AppColor.subtitle),
            const SizedBox(width: 6),
            Text(label, style:  TextStyle(color: AppColor.title, fontSize: context.text12)),
          ],
        ),
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

  // --- SEARCH RESULT SECTION ---
  Widget _buildSearchResultSection(BuildContext context) {
    return Obx(() {
      final query = _searchQuery.value.trim();
      if (query.isEmpty) return const SizedBox.shrink();

      final lat = _locationController.latitude.value;
      final lon = _locationController.longitude.value;
      final services = _serviceListController.services;

      final filtered = services.where((s) {
        if (s.latitude == null || s.longitude == null) return false;
        final d = Geolocator.distanceBetween(lat, lon, s.latitude!, s.longitude!) / 1000;
        final matches = s.serviceName.toLowerCase().contains(query.toLowerCase());
        return d <= 20 && matches;
      }).toList();

      if (filtered.isEmpty) {
        return Column(
          children: [
            SizedBox(height: context.sHeight * 0.25),
            Center(
              child: Column(
                children: [
                  Icon(Icons.search_off, size: 80, color: AppColor.subtitle.withOpacity(0.4)),
                  const SizedBox(height: 16),
                  Text("No Search Available",
                      style: TextStyle(fontSize: context.text14, fontWeight: FontWeight.bold, color: AppColor.title)),
                  const SizedBox(height: 8),
                  Text(
                    "We couldn't find anything for '$query'.\nPlease try a different keyword.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: context.text12,
                      color: AppColor.subtitle,
                    ),
                  ),                ],
              ),
            ),
          ],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.sHeight * 0.02),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: _sectionTitle("Search Results for '$query'", context),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.8),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final s = filtered[index];
              return ServiceCard(service: s);
            },
          ),
        ],
      );
    });
  }

  // --- HELPERS ---
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

  Widget _sectionTitle(String title, BuildContext context) {
    return Row(
      children: [
        Container(width: 5, height: 16, decoration: BoxDecoration(color: AppColor.primary, borderRadius: BorderRadius.circular(5))),
        const SizedBox(width: 8),
        Text(title, style: GoogleFonts.poppins(fontSize: context.text14, fontWeight: FontWeight.w500, color: AppColor.title)),
      ],
    );
  }
}