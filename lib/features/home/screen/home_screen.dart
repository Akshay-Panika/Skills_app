import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:skills_app/core/constant/app_color.dart';
import 'package:skills_app/core/constant/app_size.dart';
import 'package:skills_app/features/home/widget/category_card.dart';
import '../../category/controller/category_controller.dart';
import '../../location/controller/location_controller.dart';
import '../../notification/screen/notification_screen.dart';
import '../../search/screen/search_screen.dart';
import '../../service/controller/service_list_controller.dart';
import '../../service/screen/service_details_screen.dart';
import '../controller/home_screen_controller.dart';
import '../widget/home_shimer_card.dart';
import '../widget/invite_friend_card.dart';
import '../widget/service_card.dart';

class HomeScreenController extends GetxController {
  final CategoryController categoryController = Get.find();
  final ServiceListController serviceController = Get.find();
  final LocationController locationController = Get.find();

  bool get isLoading =>
      categoryController.isLoading.value ||
          serviceController.isLoading.value ||
          !locationController.isLocationLoaded.value;

  Future<void> onRefresh() async {
    try {
      await Future.wait([
        categoryController.getCategories(),
        serviceController.fetchServiceList(),
        locationController.fetchLocation(),
      ]);
    } catch (e) {
      debugPrint("Refresh Error: $e");
    }
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocationController _getLocationController = Get.find<LocationController>();

  String get userCity => _getLocationController.city.value;
  String get userState => _getLocationController.state.value;

  final CategoryController _categoryController = Get.find<CategoryController>();
  final ServiceListController _serviceListController = Get.find<ServiceListController>();
  bool  _isFree = false;

  final ScrollController _scrollController = ScrollController();
  double _lastOffset = 0.0;

  final HomeScreenController homeController = Get.find<HomeScreenController>();


  @override
  void initState() {
    super.initState();
    if (!_getLocationController.isLocationLoaded.value) {
      _getLocationController.fetchLocation();
    }
    _scrollController.addListener(() {
      double offset = _scrollController.offset;

      if (offset > _lastOffset) {
        Get.find<ScrollStatusController>().status.value = "Scrolling Down";
      } else if (offset < _lastOffset) {
        Get.find<ScrollStatusController>().status.value = "Scrolling Up";
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
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        surfaceTintColor: AppColor.primary,
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        toolbarHeight: 0,
        // systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Obx(() {
        if (homeController.isLoading) {
          return HomeShimmerCard();
        }
          return RefreshIndicator(
            color: AppColor.primary,
            onRefresh: () => homeController.onRefresh(),
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
            
                SliverToBoxAdapter(
                  child: Container(
                    color: AppColor.primary,
                    padding: EdgeInsets.all(context.sWidth*0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children:  [
                            Padding(
                              padding:  EdgeInsets.symmetric(horizontal: context.sWidth*0.02),
                              child: FaIcon(FontAwesomeIcons.chalkboardTeacher, color: Colors.white, size: context.sWidth*0.08),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    // Icon(Icons.location_on,size: 10,color: Colors.green.shade700,),
                                    Text(" Skill Daan",
                                        style: TextStyle(fontSize: context.text12, color: Colors.white,fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                SizedBox(height: 2),
                                Obx(() {
                                  if (!_getLocationController.isLocationLoaded.value) {
                                    return Text("Loading...", style: TextStyle(color: Colors.white),);
                                  }
            
                                  if (userCity.isEmpty || userState.isEmpty) {
                                    return Text("Location not found", style: TextStyle(color: Colors.white),);
                                  }
            
                                  return Row(
                                    spacing: 2,
                                    children: [
                                      Icon(Icons.location_on,size: context.sWidth*0.03,color: Colors.white,),
                                      Text(
                                        "$userCity, $userState",
                                        style: TextStyle(
                                          fontSize: context.text10,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
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
                              icon: const Icon(Icons.bookmark, color: Colors.white,),
                            ),
            
                            IconButton(
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen(),)),
            
                              icon: const Icon(Icons.notifications,color: Colors.white,),
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
                    height: context.sWidth*0.14,
                    child: Row(
                      spacing: context.sWidth*.02,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(),)),
                            child: Container(
                              height:  context.sWidth*0.09,
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: AppColor.white,
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
                        Transform.scale(
                          scale: 0.8,
                          child: Switch(
                            value: _isFree,
            
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
                                _isFree = value;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
            
                 SliverToBoxAdapter(child: SizedBox(height: context.sHeight*0.02,),),
            
                SliverToBoxAdapter(
                  child: Obx((){
                    return  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(_categoryController.categoryList.isNotEmpty)
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              spacing: 10,
                              children: [
                                Container(
                                  width: 5,
                                  height: 16,
                                  decoration: BoxDecoration(
                                      color: Color(0xFF0D6E6E),
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                ),
                                Text(
                                  "Grow Your Skills",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if(_categoryController.categoryList.isNotEmpty)
                        SizedBox(height: 16,),
            
                        if(_categoryController.categoryList.isNotEmpty)
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
            
                             return CategoryCard( category: category,);
                            },
                          ),
                        ),
                        if(_categoryController.categoryList.isNotEmpty)
                        SizedBox(height: context.sHeight*0.02,),
            
                        InviteFriendCard(),
                      ],
                    );
                  }),
                ),
                SliverToBoxAdapter(child: SizedBox(height: context.sHeight*0.02,),),

                SliverToBoxAdapter(
                  child: Obx(() {
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

                      final matchesFree = _isFree ? s.serviceStatus == false : true;

                      return distance <= 20 && matchesFree;
                    }).toList();

                    if (nearby.isEmpty) {
                      debugPrint("No services Near You");
                      return Padding(
                        padding:  EdgeInsets.only(top: _categoryController.categoryList.isNotEmpty ?0:100),
                        child: EmptyServiceWidget(),
                      );
                    }
            
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            spacing: 10,
                            children: [
                              Container(
                                width: 5,
                                height: 16,
                                decoration: BoxDecoration(
                                    color: Color(0xFF0D6E6E),
                                    borderRadius: BorderRadius.circular(5)
                                ),
                              ),
                              Text(
                                "Trending Courses",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w700,
                                ),
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
                ),
                SliverToBoxAdapter(child: SizedBox(height: context.sHeight*0.06,),),
              ],
            ),
          );
        }
      ),
    );
  }
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
        color: AppColor.primary,
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