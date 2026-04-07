import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skills_app/core/constant/app_color.dart';
import 'package:skills_app/core/widget/app_card.dart';
import '../../../core/constant/app_size.dart';
import '../../../core/widget/flutter_toast.dart';
import '../../service/controller/service_delete_controller.dart';
import '../../service/controller/service_list_controller.dart';
import '../../service/screen/service_details_screen.dart';
import '../controller/service_list_by_user_controller.dart';
import '../repository/service_list_byuser_repository.dart';
import '../widget/skill_empty_card.dart';
import 'add_skill_screen.dart';

class AdsScreen extends StatefulWidget {
  const AdsScreen({super.key});

  @override
  State<AdsScreen> createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {
  final controller = Get.put(
    ServiceListByUserController(repository: ServiceListByUserRepository()),
  );
  final deleteController = Get.put(ServiceDeleteController());

  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surface,
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
      padding: EdgeInsets.only(top: context.sWidth*0.16,
        left: context.sWidth*0.04,
        right: context.sWidth*0.04,
        bottom: context.sWidth*0.04,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                      fontSize: context.text20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Obx(() {
            final list = controller.serviceList;
            final total = list.length;
            final active = list.where((s) => s.serviceStatus).length;
            final inactive = list.where((s) => !s.serviceStatus).length;

            return Row(
              spacing: 10,
              children: [
                _statBox(context, label: 'All', value: '$total'),
                _statBox(context, label: 'Active', value: '$total'),
                _statBox(context, label: 'Inactive', value: '${0}')
              ],
            );
          }),
        ],
      ),
    );
  }
  Widget _statBox(BuildContext context, {required String label, required String value}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    color: Colors.white, fontSize: context.text12)),
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
            spacing: 10,
            children: ['All', 'Active', 'Inactive'].map((filter) {
              final selected = _filter == filter;
              return AppCard(
                onTap: () => setState(() => _filter = filter),
                color: selected ? AppColor.primary : AppColor.surface,
                padding: EdgeInsets.symmetric(horizontal: context.sWidth*0.04,vertical: context.sWidth*0.01),
                margin: EdgeInsets.zero,
                child: Text(filter,
                  style: TextStyle(fontSize: context.text12, fontWeight: FontWeight.w500, color: selected ? Colors.white : AppColor.subtitle,),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Column(
          children: [
            LinearProgressIndicator(color: AppColor.primary, minHeight: 2),
            const Expanded(child: SizedBox()),
          ],
        );
      }

      final list = controller.serviceList;

      if (list.isEmpty) {
        return const SkillEmptyCard();
      }
      if (_filter == "Inactive") {
        return const SkillEmptyCard();
      }
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final s = list[index];
          return SkillCard(
            title: s.serviceName,
            price: s.serviceAmount != null
                ? "₹${double.tryParse(s.serviceAmount!)?.toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), '') ?? s.serviceAmount!}"
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
                child: image.isNotEmpty
                    ? Image.network(
                  image,
                  width: context.sHeight*0.1,
                  height: context.sHeight*0.1,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      _placeholder(context),
                )
                    : _placeholder(context),
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
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ServiceDetailsScreen(
                serviceId: serviceId.toString(),
              ),
            ),
          ),
        ),

        Positioned(
          right: -5, top: -5,
          child:  _popupMenu(context, deleteController, listController),)
      ],
    );
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      color: AppColor.surface,
      child: Icon(Icons.image_not_supported_outlined,
          size: 24, color: AppColor.subtitle.withOpacity(0.5)),
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
          final bool? confirm = await _showDialog(
            context,
            icon: Icons.edit_outlined,
            iconBg: AppColor.primary.withOpacity(0.1),
            iconColor: AppColor.primary,
            title: "Edit Service?",
            subtitle: "Do you want to update this service?",
            confirmLabel: "Edit",
            confirmColor: AppColor.primary,
          );
          if (confirm == true) {
            final service = listController.serviceList
                .firstWhere((e) => e.id == serviceId);
            Get.to(() => AddSkillScreen(isEdit: true, serviceData: service));
          }
        }

        if (value == "delete") {
          final bool? confirm = await _showDialog(
            context,
            icon: Icons.delete_outline_rounded,
            iconBg: AppColor.error.withOpacity(0.1),
            iconColor: AppColor.error,
            title: "Delete Service?",
            subtitle: "This action cannot be undone. Are you sure?",
            confirmLabel: "Delete",
            confirmColor: AppColor.error,
          );
          if (confirm == true) {
            await deleteController.deleteService(
                userId: userId, serviceId: serviceId);
            if (deleteController.message.value.contains("success")) {
              listController.removeService(serviceId);
              FlutterToast.success(deleteController.message.value);
              Get.find<ServiceListController>().fetchServiceList();
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

  Future<bool?> _showDialog(
      BuildContext context, {
        required IconData icon,
        required Color iconBg,
        required Color iconColor,
        required String title,
        required String subtitle,
        required String confirmLabel,
        required Color confirmColor,
      }) {
    return Get.dialog<bool>(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                    color: iconBg, shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(height: 12),
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13,
                      color: AppColor.subtitle,
                      height: 1.5)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(result: false),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade200),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding:
                        const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text("Cancel",
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(result: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: confirmColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding:
                        const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(confirmLabel,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}