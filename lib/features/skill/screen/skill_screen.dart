import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skills_app/core/constant/app_color.dart';
import 'package:skills_app/core/widget/app_card.dart';
import 'package:skills_app/features/skill/model/service_list_by_user_model.dart';
import '../../../core/constant/app_size.dart';
import '../../../core/widget/app_dilog.dart';
import '../../../core/widget/app_error_card.dart';
import '../../notification/screen/notification_screen.dart';
import '../controller/service_delete_controller.dart';
import '../controller/service_list_by_user_controller.dart';
import '../widget/skill_empty_card.dart';

class AdsScreen extends StatefulWidget {
  const AdsScreen({super.key});

  @override
  State<AdsScreen> createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {
  late PageController _pageController;
  final _serviceListController = Get.find<ServiceListByUserController>();
  final _deleteController = Get.find<ServiceDeleteController>();

  final List<ScrollController> _scrollControllers = [
    ScrollController(),
    ScrollController(),
    ScrollController(),
  ];

  int _currentIndex = 0;
  final List<String> _filters = ['All', 'Free', 'Paid'];

  List<int> selectedIds = [];
  bool showActionBar = false;


  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }
  void toggleSelection(int id) {
    setState(() {
      if (selectedIds.contains(id)) {
        selectedIds.remove(id);
      } else {
        selectedIds.add(id);
      }

      showActionBar = selectedIds.isNotEmpty;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surface,
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        toolbarHeight: 10,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildDarkHeader(context),
          _buildFilterRow(context),
          Expanded(child: _buildList()),
        ],
      ),
    );
  }

  Widget _buildDarkHeader(BuildContext context) {
    return Container(
      color: AppColor.primary,
      padding: EdgeInsets.only(
        left: context.sWidth * 0.04,
        right: context.sWidth * 0.04,
        bottom: context.sWidth * 0.04,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Top Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MY Courses',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: context.text10,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Skills Dashboard',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: context.text16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              AppCard(
                color: Colors.white.withOpacity(0.15),
                borderRadius: context.sWidth*0.02,
                padding: EdgeInsets.all( context.sWidth*0.018,),
                margin: EdgeInsets.zero,
                child:  Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white,
                  size: context.sWidth*0.05,
                ),
                onTap: () => Get.to(() => NotificationScreen()),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// Stats
          Obx(() {
            final list = _serviceListController.serviceList;
            final total = list.length;
            final free = list.where((s) => !s.serviceStatus).length;
            final paid = list.where((s) => s.serviceStatus).length;

            return Row(
              spacing: 12,
              children: [
                _statBox(context, label: 'All', value: '$total'),
                _statBox(context, label: 'Free', value: '$free'),
                _statBox(context, label: 'Paid', value: '$paid'),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _statBox(BuildContext context,
      {required String label, required String value}) {
    return Expanded(
      child: AppCard(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.all(12),
        color: Colors.white.withOpacity(0.07),
        child: Row(
          spacing: context.sWidth*0.02,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label,
                style:
                GoogleFonts.poppins(color: Colors.white, fontSize: context.text14,fontWeight: FontWeight.w500)),

            Text(value,
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: context.text14,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterRow(BuildContext context) {
    return Container(
      height: context.sWidth*0.14,
      color: AppColor.white,
      padding: const EdgeInsets.symmetric(horizontal: 16,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'My listings',
            style: GoogleFonts.poppins(
              fontSize: context.text14,
              fontWeight: FontWeight.w500,
              color: AppColor.title,
            ),
          ),

          showActionBar?
          _futcherAction():
          Row(
            children: List.generate(_filters.length, (index) {
              final filter = _filters[index];
              final selected = _currentIndex == index;

              return AnimatedScale(
                duration: const Duration(milliseconds: 200),
                scale: selected ? 1.05 : 1.0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: AppCard(
                    onTap: () {
                      setState(() => _currentIndex = index);

                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    color:
                    selected ? AppColor.primary : AppColor.surface,
                    padding: EdgeInsets.symmetric(
                      horizontal: context.sWidth * 0.04,
                      vertical: context.sWidth * 0.01,
                    ),
                    margin: EdgeInsets.zero,
                    child: Text(
                      filter,
                      style: GoogleFonts.poppins(
                        fontSize: context.text12,
                        fontWeight: FontWeight.w500,
                        color: selected ? Colors.white : AppColor.subtitle,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return Obx(() {

      if (!_serviceListController.isLoading.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController.hasClients) {
            if (_pageController.page?.round() != _currentIndex) {
              _pageController.jumpToPage(_currentIndex);
            }
          }
        });
      }

      if (_serviceListController.isLoading.value) {
        return Column(
          children: [
            LinearProgressIndicator(color: AppColor.primary, minHeight: 2),
            const Expanded(child: SizedBox()),
          ],
        );
      }

      if (_serviceListController.errorMessage.isNotEmpty) {
        return AppErrorCard(
          message: _serviceListController.errorMessage.value,
          title: "Connection Problem",
          onRetry: () => _serviceListController.fetchMyServices(),
        );
      }

      return PageView.builder(
        key: const PageStorageKey('pageView'),
        controller: _pageController,
        onPageChanged: (index) {setState(() {_currentIndex = index;});},

        itemCount: _filters.length,

        itemBuilder: (context, pageIndex) {
          final allList = _serviceListController.serviceList;

          final filteredList = pageIndex == 0
              ? allList
              : pageIndex == 1
              ? allList.where((s) => !s.serviceStatus).toList()
              : allList.where((s) => s.serviceStatus).toList();

          if (filteredList.isEmpty) {
            return const SkillEmptyCard();
          }

          return ListView.builder(
            key: PageStorageKey(pageIndex),
            controller: _scrollControllers[pageIndex],
            padding:  EdgeInsets.symmetric(horizontal: context.sWidth*0.03, vertical: context.sWidth*0.03,),
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              final list = filteredList[index];
              return Padding(
                padding:  EdgeInsets.only(
                  bottom: index == filteredList.length - 1 ? context.sWidth*0.2 : 0,
                ),
                child: SkillCard(
                  key: ValueKey(list.id),
                  list: list,
                  isSelected: selectedIds.contains(list.id),
                  onLongPress: () {
                    toggleSelection(list.id);
                  },
                  onTap: () {
                    if (showActionBar) {
                      toggleSelection(list.id);
                    } else {
                      Get.toNamed('/service-details', parameters: {
                        'id': list.id.toString(),
                      });
                    }
                  },
                  showActionBar: showActionBar,
                ),
              );
            },
          );
        },
      );
    });
  }

  Widget _futcherAction(){
    return  Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if(selectedIds.length == 1)
          IconButton(
            onPressed: () async {
              if (selectedIds.length != 1) return;
              final selectedId = selectedIds.first;
              final confirm = await AppDialog.show(
                context,
                title: "Edit Skill?",
                message: "Do you want to update this skill?",
                confirmText: "Edit",
                cancelText: "Cancel",
              );
              if (confirm == true) {
                final serviceData = _serviceListController.serviceList.firstWhere((s) => s.id == selectedId);
                Get.toNamed('/add-skill', arguments: {
                  "isEdit": true, "serviceData": serviceData,
                });
                setState(() {
                  selectedIds.clear();
                  showActionBar = false;
                });
              }
            },
            icon: Icon(Icons.edit, color: Colors.grey.shade500),
          ),

        IconButton(
            onPressed: () async {
              if (selectedIds.isEmpty) return;

              final confirm = await AppDialog.show(
                context,
                title: "Delete Skill?",
                message: "Do you want to delete selected skills?",
                confirmText: "Delete",
                cancelText: "Cancel",
              );

              if (confirm == true) {
                await _deleteController.deleteService(
                  serviceIds: List<int>.from(selectedIds),
                );

                setState(() {
                  selectedIds.clear();
                  showActionBar = false;
                });
              }
            },
            icon: Icon(Icons.delete,color: Colors.grey.shade500,)),
        IconButton(
          onPressed: () {
            setState(() {
              selectedIds.clear();
              showActionBar = false;
            });
          },
          icon: Icon(Icons.close,color: AppColor.primary,),
        ),
      ],
    );
  }
}
class SkillCard extends StatelessWidget {
  final ServiceModel list;
  final bool isSelected;
  final VoidCallback onLongPress;
  final VoidCallback onTap;
  final bool showActionBar;
  const SkillCard({super.key, required this.list, required this.isSelected, required this.onLongPress, required this.onTap, required this.showActionBar,});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Stack(
        children: [
          AppCard(
            margin:  EdgeInsets.only(bottom: context.sWidth*0.02,),
            padding: EdgeInsets.all(context.sWidth*0.02, ),
            child: Row(
              spacing: context.sWidth*0.03,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(context.sWidth*0.03),
                  child: CachedNetworkImage(
                    imageUrl: list.serviceImage,
                    fit: BoxFit.cover,
                    width: context.sHeight*0.1,
                    height: context.sHeight*0.1,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[100],
                      alignment: Alignment.center,
                      child: FaIcon(
                        FontAwesomeIcons.chalkboardTeacher,
                        color: Colors.grey[400],
                        size: context.sWidth*0.06,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image_outlined, color: Colors.grey, size: 25),
                    ),
                  ),
                ),
          
                Expanded(
                  child: Column(
                    spacing: 20,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
          
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                list.serviceName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: context.text12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.title,
                                ),
                              ),
                              Container(width: context.sWidth*0.12,height: context.sWidth*0.05,color: Colors.transparent,)
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                list.category?.categoryName ?? "Category",
                                style: GoogleFonts.poppins(
                                  color: AppColor.primary,
                                  fontSize: context.text12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(height: 1,width: 10,color: AppColor.primary,),
                              SizedBox(width: context.sWidth*0.03,),
                              Text(
                                list.subcategory?.subcategoryName ?? "Subcategory",
                                style: GoogleFonts.poppins(
                                  color: AppColor.title,
                                  fontSize: context.text12,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: context.sWidth*0.01,),
                          Text(
                            list.serviceDescription,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                            fontSize: context.text12,
                            color: AppColor.subtitle,
                            height: 1.45,
                            overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 2,
                          ),
                        ],
                      ),
          
                      Row(
          
                        children: [
                          AppCard(
                            color: AppColor.primary.withOpacity(0.1),
                            padding:  EdgeInsets.symmetric(vertical: 3,horizontal: 12),
                            margin: EdgeInsets.zero,
                            child: Center(
                              child: Text(
                                list.serviceAmount != null
                                    ? "₹${double.tryParse(list.serviceAmount!)?.toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), '') ?? list.serviceAmount!}"
                                    : "Free",
                                style: GoogleFonts.poppins(
                                  color: AppColor.primary,
                                  fontSize: context.text12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
          
          
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.visibility_outlined, size: 14, color: AppColor.subtitle),
                                const SizedBox(width: 4),
                                Text(
                                  'views',
                                  style: GoogleFonts.poppins(
                                    fontSize: context.text12,
                                    color: AppColor.subtitle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
          
              ],
            ),
          ),
          
          Positioned(
              top: 5,right: 5,
              child: showActionBar
              ? _checkBox(context, isSelected, onLongPress)
              : SizedBox())
        ],
      ),
    );
  }

  Widget _checkBox(
      BuildContext context,
      bool isSelected,
      VoidCallback onChanged,
      ) {
    return Checkbox(
      value: isSelected,
      activeColor: AppColor.primary,
      side: const BorderSide(color: Colors.grey, width: 2),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onChanged: (_) => onChanged(),
    );
  }
}