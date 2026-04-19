import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skills_app/core/constant/app_color.dart';
import 'package:skills_app/core/constant/app_size.dart';
import 'package:skills_app/features/home/widget/category_card.dart';
import '../../category/controller/category_controller.dart';
import '../../location/controller/location_controller.dart';
import '../../location/widget/location_card.dart';
import '../../notification/screen/notification_screen.dart';
import '../../search/screen/search_screen.dart';
import '../../service/controller/service_list_controller.dart';
import '../controller/home_scroll_controller.dart';
import '../widget/home_shimer_card.dart';
import '../widget/invite_friend_card.dart';
import '../widget/section_header.dart';
import '../widget/service_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _homeScrollController = Get.find<HomeScrollController>();
  final _locationController = Get.find<LocationController>();
  final _categoryController = Get.find<CategoryController>();
  final _serviceListController = Get.find<ServiceListController>();
  bool  _isFree = false;


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
        final isLoading = !_locationController.isLocationLoaded.value
        || _categoryController.isLoading.value;

        if (isLoading) {
          return HomeShimmerCard();
        }

        return RefreshIndicator(
          color: AppColor.primary,
          onRefresh: () async {
            await Future.wait([
              _categoryController.getCategories(),
              _serviceListController.fetchServiceList(),
            ]);
          },
          child: CustomScrollView(
            controller: _homeScrollController.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
          
              SliverToBoxAdapter(
                child: Obx((){
                    final _city = _locationController.city.value;
                    final _state = _locationController.state.value;
                    return Container(
                      color: AppColor.primary,
                      padding: EdgeInsets.only(left: context.sWidth*0.02,right: context.sWidth*0.02,bottom: context.sWidth*0.026,top: context.sWidth*0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children:  [
                              Padding(
                                padding:EdgeInsets.symmetric(horizontal: context.sWidth*0.02),
                                child: FaIcon(FontAwesomeIcons.chalkboardTeacher, color: AppColor.white, size: context.sWidth*0.08),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.locationDot,
                                        size: context.sWidth*0.02,
                                        color: AppColor.white,
                                      ),
                                      SizedBox(width: context.sWidth*0.01),
                                      Text(
                                        "Location",
                                        style: GoogleFonts.poppins(
                                          fontSize: context.text10,
                                          color: AppColor.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    spacing: 2,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      (_city.isNotEmpty || _state.isNotEmpty)?
                                      Text(
                                        "$_city, $_state",
                                        style: GoogleFonts.poppins(
                                          fontSize: context.text12,
                                          fontWeight: FontWeight.w500,
                                          color: AppColor.white,
                                        ),
                                      ):Text('')
                                    ],
                                  )
          
                                ],
                              ),
                            ],
                          ),
          
                          Row(
                            children: [
          
                              InkWell(
                                onTap: () => Get.toNamed('/wishlist'),
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  margin: const EdgeInsets.only(right: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.bookmark,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => Get.to(() => NotificationScreen()),
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  margin: const EdgeInsets.only(right: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.notifications_none_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          )
          
                        ],
                      ),
                    );
                  }),
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
                            padding:  EdgeInsets.symmetric(horizontal: context.sWidth*0.02),
                            decoration: BoxDecoration(
                              color: AppColor.white,
                              borderRadius: BorderRadius.circular(context.sWidth*0.02),
                              border: Border.all(
                                color: Colors.grey.withOpacity(.3),
                                width: .5,
                              ),
                            ),
                            child:  Row(
                              children: [
                                Icon(Icons.search, color: Colors.grey),
                                SizedBox(width: context.sWidth*0.02),
                                Text(
                                  "Search skills…",
                                  style: GoogleFonts.poppins(color: Colors.grey,fontSize: context.text12),
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
                          thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
                                (states) {
                              if (states.contains(MaterialState.selected)) {
                                return  Icon(
                                  Icons.currency_rupee,
                                  size: context.sWidth*0.04,
                                  color: Colors.white,
                                );
                              }
                              return  Icon(
                                Icons.currency_rupee_outlined,
                                size: context.sWidth*0.04,
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
                  if (_categoryController.categoryList.isEmpty) return const SizedBox();
          
                  return  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(
                        title: "Grow Your Skills",
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
                      if(_categoryController.categoryList.isNotEmpty)
                      SizedBox(height: context.sHeight*0.02,),
          
                      InviteFriendCard(),
                    ],
                  );
                }),
              ),
              SliverToBoxAdapter(child: SizedBox(height: context.sHeight*0.01,),),
          
              if(_serviceListController.services.isNotEmpty)
              SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverSearchBarDelegate(
                    color:  Colors.white,
                    height: context.sWidth * 0.12,
                      padding: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              spacing: context.width*0.02,
                              children: [
                                Container(
                                  width: context.width*0.01,
                                  height: context.width*0.03,
                                  decoration: BoxDecoration(
                                    color: AppColor.primary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
          
                                Text("Trending Skills",
                                  style:  GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: context.text14,
                                    color: AppColor.title,
                                  ),
                                ),
                              ],
                            ),
          
                            Obx(() => InkWell(
                              onTap: () {
                                if (_homeScrollController.isHeaderPinned.value) {
                                  _homeScrollController.scrollController.animateTo(0,
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                  );
                                } else {
                                  _homeScrollController.scrollController.animateTo(
                                    HomeScrollController.pinThreshold,
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                              child: Row(
                                children: [
                                  Text(
                                    _homeScrollController.isHeaderPinned.value ? "See Less" : "See All",
                                    style:  GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: context.text14,
                                      color: AppColor.title,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  AnimatedRotation(
                                    turns: _homeScrollController.isHeaderPinned.value ? 0.5 : 0.0,
                                    duration: const Duration(milliseconds: 300),
                                    child:  FaIcon(
                                      FontAwesomeIcons.arrowUpLong,
                                      size: context.sWidth*0.03,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          ],
                        ),
                      )
                  ),
                ),
          
              Obx(() {
                final hasLocation = _locationController.city.value.isNotEmpty ||
                    _locationController.state.value.isNotEmpty;
          
                final nearby = _serviceListController.services.where((s) {
                  return _isFree ? s.serviceStatus == false : true;
                }).toList();
          
                if (nearby.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: _categoryController.categoryList.isNotEmpty
                            ? context.sWidth * 0.1
                            : context.sWidth * 0.6,
                      ),
                      child: hasLocation ? EmptyServiceWidget() : LocationCard(),
                    ),
                  );
                }
          
                return SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: context.sWidth * 0.03),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final service = nearby[index];
                        return ServiceCard(service: service);
                      },
                      childCount: nearby.length,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: context.sWidth * 0.02,
                      mainAxisSpacing: context.sWidth * 0.02,
                      childAspectRatio: context.sWidth * 0.002,
                    ),
                  ),
                );
              }),
              SliverToBoxAdapter(child: SizedBox(height: context.sHeight*0.1,),),
            ],
          ),
        );
      }
      ),
    );
  }
}





class _SliverSearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final Key? key;
  _SliverSearchBarDelegate({required this.child, required this.height,this.color, this.padding, this.key});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      key: key,
      height: height,
      child: Container(
        color: color?? AppColor.primary,
        padding: padding ?? EdgeInsets.symmetric(horizontal: 12),
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