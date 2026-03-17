import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import '../../category/controller/category_controller.dart';
import '../../category/screen/category_screen.dart';
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
  final CategoryController _categoryController = Get.put(CategoryController());
  final ServiceListController _serviceListController = Get.put(ServiceListController(ServiceListRepository()));
  bool  _isPaid = false;

  final ScrollStatusController scrollController = Get.find();
  final ScrollController _scrollController = ScrollController();
  double _lastOffset = 0.0;

  @override
  void initState() {
    super.initState();

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
                          Text(
                            "Pune, Maharashtra",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.black),
                          ),
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
            child: Padding(
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
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 10)),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 215,
              child: Obx((){
                if(_categoryController.isLoading.value){
                  return const Center(child: CircularProgressIndicator());
                }
                return  GridView.builder(
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
                );
              }),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 10)),

          SliverToBoxAdapter(
            child: Container(
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
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding: const EdgeInsets.only(top: 10,left: 10),
                  child: const Text(
                    'Recent Viewed Services',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  height: 200,
                  child: Obx(() {
                    if (_serviceListController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (_serviceListController.services.isEmpty) {
                      return const Center(child: Text("No recent services"));
                    }
                    final filteredServices = _isPaid
                        ? _serviceListController.services.where((s) => s.serviceStatus).toList()
                        : _serviceListController.services;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredServices.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final service = filteredServices[index];
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: ServiceCard(service: service),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Fresh Recommended Services',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Obx(() {
                    if (_serviceListController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (_serviceListController.services.isEmpty) {
                      return const Center(child: Text("No services available"));
                    }
                    final filteredServices = _isPaid
                        ? _serviceListController.services.where((s) => s.serviceStatus).toList()
                        : _serviceListController.services;

                    return GridView.builder(
                      itemCount: filteredServices.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        mainAxisExtent: 200,
                      ),
                      itemBuilder: (context, index) {
                        final service = filteredServices[index];
                        return ServiceCard(service: service);
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 50)),
        ],
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final ServiceListModel service;
  const ServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ServiceDetailsScreen(
            services: Get.find<ServiceListController>().services,
            serviceId: service.id.toString(),),
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
                            children: const [
                              Icon(Icons.location_on,
                                  size: 12, color: Colors.lightBlueAccent),
                              Text(
                                "5 km",
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