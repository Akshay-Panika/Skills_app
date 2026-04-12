import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:skills_app/core/constant/app_color.dart';
import 'package:skills_app/core/widget/app_card.dart';
import '../../../core/constant/app_size.dart';
import '../../../core/widget/app_dilog.dart';
import '../../../core/widget/flutter_toast.dart';
import '../../notification/screen/notification_screen.dart';
import '../controller/service_delete_controller.dart';
import '../../service/controller/service_list_controller.dart';
import '../controller/service_list_by_user_controller.dart';
import '../widget/skill_empty_card.dart';
import 'add_skill_screen.dart';

class AdsScreen extends StatefulWidget {
  const AdsScreen({super.key});

  @override
  State<AdsScreen> createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {

  final serviceListController = Get.find<ServiceListByUserController>();

  final PageController _pageController = PageController();

  int _currentIndex = 0;
  final List<String> _filters = ['All', 'Active', 'Inactive'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surface,
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        toolbarHeight: 10,
      ),
      body: Column(
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
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: context.text16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => Get.to(() => NotificationScreen()),
                child: Container(
                  width: 36,
                  height: 36,
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
          ),

          const SizedBox(height: 20),

          /// Stats
          Obx(() {
            final list = serviceListController.serviceList;
            final total = list.length;
            final active = list
                .where((s) => s.serviceStatus)
                .length;
            final inactive = list
                .where((s) => !s.serviceStatus)
                .length;

            return Row(
              spacing: 12,
              children: [
                _statBox(context, label: 'All', value: '$total'),
                _statBox(context, label: 'Active', value: '${total}'),
                _statBox(context, label: 'Inactive', value: '${0}'),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style:
                TextStyle(color: Colors.white, fontSize: context.text12)),
            const SizedBox(height: 4),
            Text(value,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: context.text18,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterRow(BuildContext context) {
    return Container(
      color: AppColor.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'My listings',
            style: TextStyle(
              fontSize: context.text12,
              fontWeight: FontWeight.w500,
              color: AppColor.title,
            ),
          ),

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
                      style: TextStyle(
                        fontSize: context.text12,
                        fontWeight: FontWeight.w500,
                        color: selected
                            ? Colors.white
                            : AppColor.subtitle,
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
      if (serviceListController.isLoading.value) {
        return Column(
          children: [
            LinearProgressIndicator(color: AppColor.primary, minHeight: 2),
            const Expanded(child: SizedBox()),
          ],
        );
      }

      return PageView.builder(
        controller: _pageController,

        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        itemCount: _filters.length,

        itemBuilder: (context, pageIndex) {
          final allList = serviceListController.serviceList;

          final filteredList = pageIndex == 0
              ? allList
              : pageIndex == 1
              ? allList.where((s) => !s.serviceStatus).toList()
              : allList.where((s) => s.serviceStatus).toList();

          if (filteredList.isEmpty) {
            return const SkillEmptyCard();
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              final s = filteredList[index];

              return SkillCard(
                title: s.serviceName,
                price: s.serviceAmount != null
                    ? "₹${double.tryParse(s.serviceAmount!)
                    ?.toStringAsFixed(2)
                    .replaceAll(RegExp(r'\.00$'), '') ?? s.serviceAmount!}"
                    : "Free",
                serviceDescription: s.serviceDescription,
                views: "0 views",
                image: s.serviceImage,
                status: s.serviceStatus ? "Active" : "Inactive",
                serviceId: s.id,
                userId: s.user,
              );
            },
          );
        },
      );
    });
  }
}
class SkillCard extends StatelessWidget {
  final int serviceId;
  final int userId;
  final String title;
  final String serviceDescription;
  final String price;
  final String views;
  final String status;
  final String image;

  const SkillCard({
    super.key,
    required this.serviceId,
    required this.userId,
    required this.title,
    required this.serviceDescription,
    required this.price,
    required this.views,
    required this.status,
    required this.image,
  });

  bool get _isActive => status == "Active";

  @override
  Widget build(BuildContext context) {
    final deleteController = Get.find<ServiceDeleteController>();
    final listController = Get.find<ServiceListByUserController>();

    return Stack(
      children: [
        AppCard(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          child: Row(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: image,
                  fit: BoxFit.cover,
                  width: context.sHeight*0.1,
                  height: context.sHeight*0.1,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[100],
                    alignment: Alignment.center,
                    child: FaIcon(
                      FontAwesomeIcons.chalkboardTeacher,
                      color: Colors.grey[400],
                      size: 25,
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
                      spacing: 5,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: context.text14,
                            fontWeight: FontWeight.w500,
                            color: AppColor.title,
                          ),
                        ),
                        Text(
                          serviceDescription,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: context.text12,
                            color: AppColor.subtitle,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      spacing: 10,
                      children: [
                        AppCard(
                          color: AppColor.primary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          margin: EdgeInsets.zero,
                          child: Text(
                            price,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: context.text12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        AppCard(
                          color: _isActive
                              ? const Color(0xFFEAF3DE)
                              : AppColor.surface,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          margin: EdgeInsets.zero,
                          child: Text(
                            status,
                            style: TextStyle(
                              color: _isActive
                                  ? const Color(0xFF3B6D11)
                                  : AppColor.subtitle,
                              fontSize: context.text12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Spacer(),
                        Text(
                          views,
                          style: TextStyle(
                            fontSize: context.text12,
                            color: AppColor.subtitle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10,),
            ],
          ),
          onTap: () {
            Get.toNamed('/service-details', parameters: {
              'id': serviceId.toString(),
            });
          },
        ),

        Positioned(
          right: -5, top: -5,
          child:  _popupMenu(context, deleteController, listController),)
      ],
    );
  }

  Widget _popupMenu(
      BuildContext context,
      ServiceDeleteController deleteController,
      ServiceListByUserController listController,
      ) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert_rounded,
          color: AppColor.subtitle, size: context.sHeight*0.025),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      elevation: 6,
      padding: EdgeInsets.zero,
      onSelected: (value) async {
        if (value == "edit") {
          final confirm = await AppDialog.show(
            context,
            title: "Edit Service?",
            message: "Do you want to update this service?",
            confirmText: "Edit",
          );
          if (confirm == true) {
            final service = listController.serviceList
                .firstWhere((e) => e.id == serviceId);

            Get.toNamed('/add-skill',
              arguments: {"isEdit": true,
                "serviceData": service,
              },
            );
            // Get.to(() => AddSkillScreen(isEdit: true, serviceData: service));
          }
        }

        if (value == "delete") {
          final confirm = await AppDialog.show(
            context,
            title: "Delete Service?",
            message: "This action cannot be undone. Are you sure?",
            confirmText: "Delete",
          );
          if (confirm == true) {
            await deleteController.deleteService(
                userId: userId, serviceId: serviceId);
            if (deleteController.message.value.contains("success")) {
              listController.removeService(serviceId);
              FlutterToast.success(deleteController.message.value);
              Get.find<ServiceListController>().fetchServiceList();
              Get.find<ServiceListByUserController>().fetchMyServices();
            } else {
              FlutterToast.error("Service not found");
            }
          }
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: "edit",
          child: _menuItem(
              context, Icons.edit_outlined, "Edit", AppColor.primary,
              AppColor.primary.withOpacity(0.08)),
        ),
        PopupMenuItem(
          value: "delete",
          child: _menuItem(
              context, Icons.delete_outline_rounded, "Delete",
              AppColor.error, AppColor.error.withOpacity(0.08)),
        ),
      ],
    );
  }

  Widget _menuItem(BuildContext context, IconData icon, String label,
      Color color, Color bgColor) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              color: bgColor, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 10),
        Text(label,
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 13, color: color)),
      ],
    );
  }

}