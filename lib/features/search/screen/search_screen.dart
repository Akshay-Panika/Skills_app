import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skills_app/core/constant/app_color.dart';
import 'package:skills_app/core/constant/app_size.dart';

import '../../category/controller/category_controller.dart';
import '../../home/widget/category_card.dart';
import '../../home/widget/section_header.dart';
import '../../location/controller/location_controller.dart';
import '../../service/controller/service_list_controller.dart';
import '../../service/widget/no_data.dart';
import '../../wishlist/controller/wishlist_toggle_controller.dart';
import '../controller/service_search_controller.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final _locationController = Get.find<LocationController>();
  final _categoryController = Get.find<CategoryController>();
  final _searchController = Get.find<ServiceSearchController>();

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

                  /// Search empty -> Categories show
                  Obx(() {
                    final isSearchEmpty =
                        _searchController.searchText.value.trim().isEmpty;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isSearchEmpty) ...[
                          _buildCategories(context),
                          SizedBox(height: context.sHeight * 0.02),
                        ],

                        /// Search Results
                        _buildSearchResults(context),
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
        bottom: 14,
        left: 12,
        right: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(
                FontAwesomeIcons.chalkboardTeacher,
                color: AppColor.white,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Skill Daan',
                style: GoogleFonts.poppins(
                  color: AppColor.white,
                  fontSize: context.text14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: context.sHeight * 0.01),

          Row(
            children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColor.white,
                ),
              ),

              Expanded(
                child: Container(
                  height: context.sHeight * 0.04,
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Obx(() {
                    return Row(
                      children: [
                        const SizedBox(width: 10),

                        FaIcon(
                          FontAwesomeIcons.search,
                          color: Colors.grey,
                          size: 16,
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: TextField(
                            controller:
                            _searchController.searchController,

                            /// API only when keyboard search pressed
                            onSubmitted: (value) {
                              _searchController.searchText.value =
                                  value.trim();

                              _searchController.searchServices();
                            },

                            textInputAction:
                            TextInputAction.search,

                            style: TextStyle(
                              fontSize: context.text12,
                              color: AppColor.subtitle,
                            ),

                            decoration: InputDecoration(
                              hintText:
                              'Find Courses, Skills, Tutors...',
                              hintStyle: TextStyle(
                                fontSize: context.text12,
                                color: AppColor.subtitle,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),

                        if (_searchController
                            .searchText.value.isNotEmpty)
                          IconButton(
                            onPressed: () {
                              _searchController
                                  .searchController
                                  .clear();

                              _searchController
                                  .searchText
                                  .value = '';

                              _searchController
                                  .serviceList
                                  .clear();
                            },
                            icon: const Icon(Icons.close),
                          ),

                        const SizedBox(width: 10),
                      ],
                    );
                  }),
                ),
              ),

              const SizedBox(width: 10),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    return Obx(() {
      final controller = Get.find<WishlistToggleController>();

      final isSearchEmpty = _searchController.searchText.value.trim().isEmpty;

      if (isSearchEmpty) {
        return const SizedBox();
      }

      if (_searchController.isLoading.value) {
        return  Padding(
          padding:  EdgeInsets.only(top:context.sWidth*0.6),
          child: Center(
            child: CircularProgressIndicator(color: AppColor.primary,),
          ),
        );
      }

      if (_searchController.serviceList.isEmpty) {
        return Padding(
          padding:  EdgeInsets.only(top:context.sWidth*0.5),
          child: NoData(),
        );
      }

      return GridView.builder(
        itemCount: _searchController.serviceList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: context.sWidth * 0.02,
          mainAxisSpacing: context.sWidth * 0.02,
          childAspectRatio: context.sWidth * 0.002,
        ),
        itemBuilder: (context, index) {
          final service = _searchController.serviceList[index];
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
                            Text(service.serviceName, style:  GoogleFonts.poppins(fontSize: context.text12,fontWeight: FontWeight.w500, color: AppColor.title)),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    service.serviceAmount != null
                                        ? "₹${double.tryParse(service.serviceAmount!)?.toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), '') ?? service.serviceAmount!}"
                                        : "Free",
                                    style:  GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: context.text12)),
                                Row(
                                  children:  [
                                    Icon(Icons.location_on, size: 12, color: Colors.green),
                                    Text(service.distance ?? "0 m", style: GoogleFonts.poppins(fontSize: context.text12, color: Colors.black87),),
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
                      onTap: () async {
                        await controller.toggleWishlist(serviceId: service.id,);
                        Get.find<ServiceListController>().toggleLocalFavorite(service.id);
                        _searchController.toggleLocalFavorite(service.id);
                      },
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        child: Icon(
                          service.isFavorite
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: service.isFavorite
                              ? AppColor.primary
                              : Colors.grey,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
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
                  // await _serviceListController.fetchServiceList();
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
      if (_categoryController.isLoading.value ||
          _categoryController.categoryList.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.sHeight * 0.03),

          SectionHeader(
            title: "Popular Skills",
            onTap: () {
              Get.toNamed('/category', parameters: {
                'id':_categoryController.categoryList.first.id.toString(),
                'name': _categoryController.categoryList.first.categoryName.toString(),
              });
            },
          ),
          SizedBox(height: context.sHeight*0.012,),
          Container(
            color: Colors.transparent,
            height: context.sWidth*0.54,
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: context.sWidth*0.03),
              scrollDirection: Axis.horizontal,
              itemCount: _categoryController.categoryList.length,
              gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: context.sWidth*0.036,
                  crossAxisSpacing: context.sWidth*0.02,
                  mainAxisExtent:context.sWidth*0.16
              ),
              itemBuilder: (context, index) {
                final category = _categoryController.categoryList[index];

                return CategoryCard( category: category,);
              },
            ),
          ),
        ],
      );
    });
  }
}