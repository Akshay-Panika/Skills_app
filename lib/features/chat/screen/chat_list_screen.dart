import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:skills_app/core/constant/app_color.dart';
import 'package:skills_app/core/constant/app_size.dart';
import 'package:skills_app/core/widget/app_card.dart';
import '../../../core/widget/app_dilog.dart';
import '../controller/booking_controller.dart';
import '../../notification/screen/notification_screen.dart';
import '../controller/booking_delete_controller.dart';

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
                  return  Center(child: CircularProgressIndicator(color: AppColor.primary,));
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

  @override
  Widget build(BuildContext context) {
    final service = item.service;

    return GestureDetector(
      onTap: () => Get.toNamed('/chat', arguments: {"serviceId": service.id}),
      child: AppCard(
        margin: const EdgeInsets.only(bottom: 10, left: 12, right: 12),
        padding: EdgeInsets.all(12),
        color: Colors.white,
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
                      radius: context.sHeight*0.034,
                      backgroundColor: AppColor.white,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(context.sHeight*0.036,),
                        child: CachedNetworkImage(
                          imageUrl: service.userProfile!.userImage.toString(),
                          fit: BoxFit.cover,
                          width: context.sHeight*0.068,
                          height: context.sHeight*0.068,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[100],
                            alignment: Alignment.center,
                            child: FaIcon(
                              FontAwesomeIcons.image,
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
                            child: Text(service.userProfile!.userName.toString(),
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
                      Row(
                        children: [
                          Icon(Icons.work,
                              size: 13, color: AppColor.subtitle),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              "${service.userProfile!.userBio.toString()}",
                              style: TextStyle(
                                  fontSize: context.text12,
                                  color: AppColor.subtitle),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),
                      Row(
                        spacing: 10,
                        children: [
                          Icon(
                            Icons.done_all,
                            size: 16,
                            color: item.status == "seen"
                                ? Colors.blue
                                : Colors.grey,
                          ),
                          Expanded(
                            child: Text(
                              "${item.message}",
                              style: TextStyle(
                                fontSize: context.text12,
                                color: AppColor.subtitle,
                                height: 1.45,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                // Service tag
                AppCard(
                  color: AppColor.primary.withOpacity(0.08),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  margin: EdgeInsets.zero,
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
                  child: AppCard(
                    color: Colors.red.withOpacity(0.08),
                    margin: EdgeInsets.zero,
                    child: Center(
                      child: const Icon(Icons.delete_outline_rounded,
                          color: Colors.red, size: 22),
                    ),
                  ),
                ),
              ],
            ),
          ],
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