import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skills_app/core/constant/app_color.dart';
import 'package:skills_app/core/widget/app_card.dart';
import '../../../core/constant/app_size.dart';
import '../../../core/widget/flutter_toast.dart';
import '../../../core/widget/my_appbar.dart';
import '../../service/controller/service_delete_controller.dart';
import '../../service/controller/service_list_controller.dart';
import '../../service/screen/service_details_screen.dart';
import '../controller/service_list_by_user_controller.dart';
import '../repository/service_list_byuser_repository.dart';
import '../widget/skill_empty_card.dart';
import 'create_add_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColor.surface,
        appBar: myAppBar(
          title: 'Skills',
          showBackButton: false,
          titleColor: AppColor.white,
          backgroundColor: AppColor.primary,
        ),
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: TabBarView(
                children: [
                  // Sell tab
                  Obx(() {
                    if (controller.isLoading.value) {
                      return Column(
                        children: [
                          LinearProgressIndicator(
                            color: AppColor.primary,
                            minHeight: 2,
                          ),
                          const Expanded(child: SizedBox()),
                        ],
                      );
                    }

                    if (controller.serviceList.isEmpty) {
                      return const SkillEmptyCard(
                        icon: Icons.storefront_outlined,
                        title: "No Ads Yet",
                        subtitle: "Your posted services will appear here",
                      );
                    }

                    return ListView.builder(
                      itemCount: controller.serviceList.length,
                      itemBuilder: (context, index) {
                        final s = controller.serviceList[index];
                        return SkillCard(
                          title: s.serviceName,
                          price: s.serviceAmount != null
                              ? "₹${s.serviceAmount}"
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
                  }),
                  // Buy tab
                  const SkillEmptyCard(
                    icon: Icons.shopping_bag_outlined,
                    title: "No Purchases Yet",
                    subtitle: "Services you book will appear here",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: AppColor.primary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: TextStyle(
              fontWeight: FontWeight.w700, fontSize: context.text12),
          unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w500, fontSize: context.text12),
          indicator: BoxDecoration(
            color: Colors.white.withOpacity(0.22),
            borderRadius: BorderRadius.circular(10),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          tabs: const [
            Tab(text: "Sell"),
            Tab(text: "Buy"),
          ],
        ),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    final deleteController = Get.find<ServiceDeleteController>();
    final listController = Get.find<ServiceListByUserController>();

    return AppCard(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ServiceDetailsScreen(
            services: Get.find<ServiceListController>().services,
            serviceId: serviceId.toString(),
            distanceText: serviceDescription,
          ),
        ),
      ),
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: image.isNotEmpty
                ? Image.network(
              image,
              width: context.sHeight * 0.1,
              height: context.sHeight * 0.1,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _imgPlaceholder(context),
            )
                : _imgPlaceholder(context),
          ),
          Expanded(
            child: Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title + menu
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: context.text14,
                          color: AppColor.title,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        serviceDescription,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: context.text12,
                            color: AppColor.subtitle,
                            height: 1.4),
                      ),

                      SizedBox(height: context.sHeight*0.01,),

                      Row(
                        spacing: 10,
                        children: [
                          AppCard(
                            margin: EdgeInsets.zero,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            color: AppColor.primary,
                            child: Text(price,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: context.text10,
                                color:  AppColor.white,
                              ),
                            ),
                          ),
                          AppCard(
                            margin: EdgeInsets.zero,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            color: AppColor.surface,
                            child: Text(status,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: context.text10,
                                color:  AppColor.primary,
                              ),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
                _popupMenu(context, deleteController, listController),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imgPlaceholder(BuildContext context) {
    return Container(
      width: context.sHeight * 0.1,
      height: context.sHeight * 0.1,
      color: AppColor.surface,
      child: Icon(Icons.image_not_supported_outlined,
          size: context.sHeight*0.016, color: AppColor.subtitle.withOpacity(0.7)),
    );
  }

  Widget _popupMenu(
      BuildContext context,
      ServiceDeleteController deleteController,
      ServiceListByUserController listController,
      ) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert_rounded, color: AppColor.title, size: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColor.surface,
      elevation: 6,
      onSelected: (value) async {
        if (value == "edit") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreateAddScreen(
                // serviceId: serviceId,
                // title: title,
                // description: serviceDescription,
                // price: price,
                // image: image,
                // status: status == "Active",
              ),
            ),
          );
        }

        if (value == "delete") {
          final bool? confirm = await Get.dialog(
            Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: AppColor.surface,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: context.sHeight * 0.05,
                      height: context.sHeight * 0.05,
                      decoration: BoxDecoration(
                        color: AppColor.error.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.delete_outline_rounded,
                          color: AppColor.error, size: context.sHeight * 0.02),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Delete Service?",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColor.title),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "This action cannot be undone.\nAre you sure?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: context.text12,
                          color: AppColor.subtitle,
                          height: 1.5),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Get.back(result: false),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: AppColor.surface, width: 1.5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text("Cancel",
                                style: TextStyle(
                                    color: AppColor.error,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Get.back(result: true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.error,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text("Delete",
                                style: TextStyle(
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
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    color: AppColor.surface,
                    borderRadius: BorderRadius.circular(8)),
                child: Icon(Icons.edit_outlined,
                    size: context.text14, color: AppColor.primary),
              ),
              const SizedBox(width: 10),
              const Text("Edit",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: AppColor.title)),
            ],
          ),
        ),
        PopupMenuItem(
          value: "delete",
          child: Row(
            children: [
              Container(
                width: context.sHeight * 0.03,
                height: context.sHeight * 0.03,
                decoration: BoxDecoration(
                    color: AppColor.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8)),
                child: Icon(Icons.delete_outline_rounded,
                    size: context.text14, color: AppColor.error),
              ),
              const SizedBox(width: 10),
              const Text("Delete",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: AppColor.error)),
            ],
          ),
        ),
      ],
    );
  }
}

