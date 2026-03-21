import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../core/widget/flutter_toast_widget.dart';
import '../../service/controller/service_delete_controller.dart';
import '../../service/controller/service_list_controller.dart';
import '../controller/service_list_by_user_controller.dart';
import '../repository/service_list_byuser_repository.dart';

class AdsScreen extends StatefulWidget {
  const AdsScreen({super.key});

  @override
  State<AdsScreen> createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {

  final controller = Get.put(
    ServiceListByUserController(
      repository: ServiceListByUserRepository(),
    ),
  );
  final deleteController = Get.put(ServiceDeleteController());
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xffF7F8FA),

        appBar: AppBar(
          toolbarHeight: 30,
          backgroundColor: Colors.white,
          title: const Text("My Ads"),
          titleTextStyle: TextStyle(fontSize: 20,color: Colors.black87, fontWeight: FontWeight.w600),
          centerTitle: false,
          actions: [
            // IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          ],
          bottom: const TabBar(
            labelColor: Colors.black,
            indicatorColor: Colors.blueAccent,
            tabs: [
              Tab(text: "Sell"),
              Tab(text: "Buy"),
            ],
          ),
        ),

        body: TabBarView(
          children: [

            Obx(() {
              if (controller.isLoading.value) {
                return Align(
                    alignment: Alignment.topCenter,
                    child: LinearProgressIndicator(color: Colors.blueAccent,minHeight: 2,));
              }

              if (controller.serviceList.isEmpty) {
                return  Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 70,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "No Bookings Yet",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Your bookings will appear here",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: controller.serviceList.length,
                itemBuilder: (context, index) {
                  final service = controller.serviceList[index];

                  return AdCard(
                    title: service.serviceName,
                    price: service.serviceAmount != null ? "₹ ${service.serviceAmount}" : "Free",
                    serviceDescription: service.serviceDescription,
                    views: "0 views",
                    image: service.serviceImage,
                    status: service.serviceStatus ? "Active" : "Inactive",
                    serviceId: service.id,
                    userId: service.user,
                  );
                },
              );
            }),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 70,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "No Bookings Yet",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Your bookings will appear here",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),

      ),
    );
  }
}

class AdCard extends StatelessWidget {
  final int serviceId;
  final int userId;
  final String title;
  final String serviceDescription;
  final String price;
  final String views;
  final String status;
  final String image;

  const AdCard({
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

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                width: 110,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(0.16),
                  image: DecorationImage(
                      image: NetworkImage(image), fit: BoxFit.cover),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),

                    Text(serviceDescription,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 6),
                    Row(
                      spacing: 10,
                      children: [
                        Text(price,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,)),
                        Text(views,
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 12)),

                        const SizedBox(width: 10),

                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),

        /// 🔥 POPUP MENU
        Positioned(
          right: 0,
          top: 0,
          child: PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == "delete") {

                /// Confirm dialog
                bool? confirm = await Get.dialog(
                  AlertDialog(
                    title: const Text("Delete Service"),
                    content: const Text("Are you sure you want to delete?"),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(result: false),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () => Get.back(result: true),
                        child: const Text("Delete"),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await deleteController.deleteService(
                      userId: userId, serviceId: serviceId);

                  if (deleteController.message.value.contains("success")) {

                    /// Remove from UI instantly
                    listController.removeService(serviceId);
                    FlutterToastWidget.success(deleteController.message.value);
                    Get.find<ServiceListController>().fetchServiceList();
                  } else {
                    FlutterToastWidget.error("Service not found");
                  }
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "edit",
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 18),
                    SizedBox(width: 8),
                    Text("Edit"),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: "delete",
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text("Delete"),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}