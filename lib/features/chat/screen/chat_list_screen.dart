import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skills_app/core/constant/app_color.dart';
import 'package:skills_app/core/constant/app_size.dart';
import 'package:skills_app/core/widget/app_card.dart';
import '../../../core/widget/app_dilog.dart';
import '../controller/booking_controller.dart';
import '../../notification/screen/notification_screen.dart';
import '../controller/booking_delete_controller.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  ChatListScreen({super.key});

  final bookingController = Get.find<BookingController>();
  final deleteController = Get.find<BookingDeleteController>();


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColor.surface,

        appBar: AppBar(
          backgroundColor: AppColor.primary,
          title: Text(
            'Chats',
            style: TextStyle(
              color: Colors.white,
              fontSize: context.text16,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
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
        ),

        body: Column(
          children: [
            _buildTabBar(context),

            Expanded(
              child: Obx(() {
                if (bookingController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                return TabBarView(
                  children: [
                    _ChatTabContent(list: bookingController.allChats),
                    _ChatTabContent(list: bookingController.buyerBookings),
                    _ChatTabContent(list: bookingController.sellerBookings),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      color: AppColor.primary,
      child: TabBar(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white60,
        labelStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: context.text12,
        ),
        indicatorColor: Colors.white,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: "ALL"),
          Tab(text: "BUYING"),
          Tab(text: "SELLING"),
        ],
      ),
    );
  }
}

class _ChatTabContent extends StatelessWidget {
  final List list;

  const _ChatTabContent({required this.list});

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return const _EmptyState();
    }

    return ListView.builder(
      itemCount: list.length,
      padding: const EdgeInsets.only(top: 20,bottom: 100),
      itemBuilder: (context, index) {
        final item = list[index];

        return ChatSkillCard(item: item);
      },
    );
  }
}

class ChatSkillCard extends StatelessWidget {
  final dynamic item;
  ChatSkillCard({super.key, required this.item});
  final deleteController = Get.find<BookingDeleteController>();

  Color get _accentColor {
    // Role ke hisaab se color change karo
    return AppColor.primary; // ya Buyer/Seller logic se
  }

  @override
  Widget build(BuildContext context) {
    final service = item.service;

    return GestureDetector(
      onTap: () => Get.toNamed('/chat', arguments: {"serviceId": service.id}),
      child: AppCard(
        margin: const EdgeInsets.only(bottom: 10, left: 12, right: 12),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar with initials
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor:
                        AppColor.primary.withOpacity(0.1),
                        child: Text(
                          "SD", // initials
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColor.primary,
                          ),
                        ),
                      ),
                      // Online indicator
                      Positioned(
                        bottom: 1,
                        right: 1,
                        child: Icon(Icons.circle,size: 12,color: AppColor.primary,),
                      ),
                    ],
                  ),
                  const SizedBox(width: 11),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name + Date
                        Row(
                          children: [
                            Expanded(
                              child: Text("SD User",
                                style: TextStyle(
                                  fontSize: context.text14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.title,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              item.createdAt.toString().substring(0,10),
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColor.subtitle),
                            ),
                          ],
                        ),

                        // Location
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined,
                                size: 13, color: AppColor.subtitle),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                "Flutter · Waidhan, Singrauli",
                                style: TextStyle(
                                    fontSize: context.text12,
                                    color: AppColor.subtitle),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        // Last message
                        const SizedBox(height: 6),
                        Text("${item.message}",
                          style: TextStyle(
                              fontSize: context.text12,
                              color: AppColor.subtitle,
                              height: 1.45),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  // Service tag
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColor.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.computer_rounded,
                            size: 11, color: AppColor.primary),
                        const SizedBox(width: 5),
                        Text("${service.serviceName}",
                          style: TextStyle(
                            fontSize: context.text10,
                            fontWeight: FontWeight.w600,
                            color: AppColor.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Delete button
                  InkWell(
                    borderRadius: BorderRadius.circular(9),
                    onTap: () async {
                      final confirm = await AppDialog.show(context,
                        title: "Delete Chat",
                        message: "Are you sure you want to delete?",
                        cancelText: "Cancel",
                        confirmText: "Delete",
                      );
                      if (confirm) {
                        await deleteController.deleteBooking(item.id);
                        Get.find<BookingController>().fetchBookings();
                      }
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Icon(Icons.delete_outline_rounded,
                          color: Colors.red, size: 16),
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

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.chat_bubble_outline,
              size: 60, color: AppColor.primary),
          SizedBox(height: 10),
          Text("No chats found",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text("Start booking services to chat"),
        ],
      ),
    );
  }
}