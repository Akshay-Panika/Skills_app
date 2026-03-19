import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../category/controller/category_controller.dart';
import '../../category/screen/category_screen.dart';
import '../../location/controller/location_controller.dart';
import '../../search/screen/search_screen.dart';
import '../../service/controller/service_list_controller.dart';
import '../../service/model/service_list_model.dart';
import '../../service/repository/service_list_repository.dart';
import '../../service/screen/service_details_screen.dart';
import 'package:share_plus/share_plus.dart';

import '../controller/home_screen_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocationController _getLocationController = Get.find<LocationController>();

  String get userCity => _getLocationController.city.value;
  String get userState => _getLocationController.state.value;

  final CategoryController _categoryController = Get.put(CategoryController());
  final ServiceListController _serviceListController = Get.put(ServiceListController(ServiceListRepository()));
  bool  _isPaid = false;

  final ScrollStatusController scrollController = Get.find();
  final ScrollController _scrollController = ScrollController();
  double _lastOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _getLocationController.fetchLocation();
    _scrollController.addListener(() {
      double offset = _scrollController.offset;

      if (offset > _lastOffset) {
        scrollController.status.value = "Scrolling Down";
      } else if (offset < _lastOffset) {
        scrollController.status.value = "Scrolling Up";
      } else {
        scrollController.status.value = "Idle";
      }

      _lastOffset = offset;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        toolbarHeight: 0,
        // systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [

          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children:  [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Icon(Icons.school, color: Colors.blueAccent, size: 30),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on,size: 10,color: Colors.grey.shade700,),
                              Text("Location",
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                            ],
                          ),
                          SizedBox(height: 2),
                          Obx(() {
                            if (!_getLocationController.isLocationLoaded.value) {
                              return Text("Loading...");
                            }

                            if (userCity.isEmpty || userState.isEmpty) {
                              return Text("Location not found");
                            }

                            return Text(
                              "$userCity, $userState",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            );
                          })

                        ],
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.bookmark, color: Colors.blueAccent,),
                      ),

                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications,color: Colors.blueAccent,),
                      ),
                    ],
                  )

                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverSearchBarDelegate(
              height: 56,
              child: Row(
                children: [

                  /// SEARCH BAR
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(),)),
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey.withOpacity(.3),
                            width: .5,
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.search, color: Colors.grey),
                            SizedBox(width: 10),
                            Text(
                              "Search skills…",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width:12),

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
            ),
          ),

           SliverToBoxAdapter(child: SizedBox(height: 20,),),

           //"Popular Skills",
          SliverToBoxAdapter(
            child: Obx((){
              if(_categoryController.isLoading.value){
                return _buildShimmerCategory();
              }
              return  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Popular Skills",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: 16,),

                  SizedBox(
                    height: 215,
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      scrollDirection: Axis.horizontal,
                      itemCount: _categoryController.categoryList.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          mainAxisExtent:65
                      ),
                      itemBuilder: (context, index) {
                        final category = _categoryController.categoryList[index];

                        return Column(
                          spacing: 10,
                          children: [
                            InkWell(
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryScreen(categoryId: category.id.toString(),),)),
                              child: Container(
                                height: 65,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    category.categoryImage ?? "",
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Icon(
                                          Icons.image_not_supported_outlined,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              category.categoryName ?? "",
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style:  TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  height: 1.2,
                                  color: Colors.grey.shade700
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16,),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// top row
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.blueAccent.withOpacity(.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.card_giftcard,
                                color: Colors.blueAccent,
                              ),
                            ),

                            const SizedBox(width: 12),

                            /// text
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Invite Friends",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Earn rewards by sharing",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        /// share button
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              final textToShare =
                                  "Check out this service:";
                              Share.share(textToShare);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                "Share",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            }),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 10)),


          SliverToBoxAdapter(
            child: Obx(() {
              final lat = _getLocationController.latitude.value;
              final lon = _getLocationController.longitude.value;

              if (_serviceListController.isLoading.value || !_getLocationController.isLocationLoaded.value) {
                return _buildServiceShimmer();
              }

              if (lat == 0.0 || lon == 0.0) {return _buildServiceShimmer();}

              final filteredServices = (_isPaid
                  ? _serviceListController.services
                  .where((s) => s.serviceStatus)
                  .toList()
                  : _serviceListController.services);

              final nearbyServices = filteredServices.where((service) {
                if (service.latitude == null || service.longitude == null) return false;

                double distanceKm = Geolocator.distanceBetween(
                  lat, lon,
                  service.latitude!,
                  service.longitude!,
                ) / 1000;

                return distanceKm <= 20;
              }).toList();

              if (nearbyServices.isEmpty) {
                debugPrint("No services Near You");
                return EmptyServiceWidget();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Recent View Services", // ✅ fixed text
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: nearbyServices.length,
                      padding: EdgeInsets.zero,
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

                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: ServiceCard(
                            service: service,
                            serviceDistance: distanceText,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 10)),

          SliverToBoxAdapter(
            child: Obx(() {
              final lat = _getLocationController.latitude.value;
              final lon = _getLocationController.longitude.value;

              if (_serviceListController.isLoading.value || !_getLocationController.isLocationLoaded.value) {
                return SizedBox.shrink();
              }

              if (lat == 0.0 || lon == 0.0) {return SizedBox.shrink();}

              final filteredServices = (_isPaid
                  ? _serviceListController.services
                  .where((s) => s.serviceStatus)
                  .toList()
                  : _serviceListController.services);

              final nearbyServices = filteredServices.where((service) {
                if (service.latitude == null || service.longitude == null) return false;

                double distanceKm = Geolocator.distanceBetween(
                  lat, lon,
                  service.latitude!,
                  service.longitude!,
                ) / 1000;

                return distanceKm <= 20;
              }).toList();

              if (nearbyServices.isEmpty) {
                debugPrint("No services Near You");
                return SizedBox.shrink();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "ALL Services", // ✅ fixed text
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: nearbyServices.length,
                    physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
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

                      return Container(
                        height: 200,
                        padding: EdgeInsets.only(bottom: 10),
                        child: ServiceCard(
                          service: service,
                          serviceDistance: distanceText,
                        ),
                      );
                    },
                  ),
                ],
              );
            }),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 50)),
        ],
      ),
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

Widget _buildShimmerCategory() {
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
            width: 120,
            color: Colors.white,
          ),
        ),

        SizedBox(height: 16),

        /// Grid shimmer
        SizedBox(
          height: 215,
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 10),
            scrollDirection: Axis.horizontal,
            itemCount: 10, // dummy items
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              mainAxisExtent: 65,
            ),
            itemBuilder: (context, index) {
              return Column(
                children: [

                  /// image box
                  Container(
                    height: 65,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  SizedBox(height: 10),

                  /// text line
                  Container(
                    height: 10,
                    width: 50,
                    color: Colors.white,
                  ),
                ],
              );
            },
          ),
        ),

        SizedBox(height: 16),

        /// Invite Card shimmer
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                children: [

                  /// icon box
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  SizedBox(width: 12),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 14, width: 120, color: Colors.white),
                      SizedBox(height: 6),
                      Container(height: 10, width: 160, color: Colors.white),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 14),

              /// button shimmer
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 30,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    ),
  );
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

class EmptyServiceWidget extends StatelessWidget {
  const EmptyServiceWidget({super.key,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [

          /// Icon
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_off,
              size: 40,
              color: Colors.green,
            ),
          ),

          const SizedBox(height: 12),

          /// Title
          const Text(
            "No Services Nearby",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 6),

          /// Subtitle
          Text(
            "We couldn’t find any services within 10 km.\nTry changing location or check later.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 14),
        ],
      ),
    );
  }
}

class _SliverSearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _SliverSearchBarDelegate({required this.child, required this.height});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      height: height,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: child,
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant _SliverSearchBarDelegate oldDelegate) {
    return oldDelegate.child != child || oldDelegate.height != height;
  }
}