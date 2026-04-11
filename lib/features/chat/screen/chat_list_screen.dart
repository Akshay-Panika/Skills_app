import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:skills_app/core/constant/app_color.dart';
import 'package:skills_app/core/constant/app_size.dart';
import 'package:skills_app/core/widget/app_card.dart';

import '../controller/booking_controller.dart';
import '../../notification/screen/notification_screen.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  ChatListScreen({super.key});

  final controller = Get.put(BookingController());

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
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                return TabBarView(
                  children: [
                    _ChatTabContent(list: controller.allChats),
                    _ChatTabContent(list: controller.buyerBookings),
                    _ChatTabContent(list: controller.sellerBookings),
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

  const ChatSkillCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final service = item.service;

    return Stack(
      children: [
        AppCard(
          onTap: () {
            Get.to(() => ChatScreen(), arguments: item);
          },
          margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          padding: const EdgeInsets.all(12),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                 AppCard(
                   margin: EdgeInsets.zero,
                   color: AppColor.primary.withOpacity(0.1),
                   padding: EdgeInsets.all(context.sWidth*0.05),
                   child:FaIcon(FontAwesomeIcons.circleUser,color: AppColor.primary,),
                 ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("SD User",
                          style: TextStyle(
                            fontSize: context.text14,
                            fontWeight: FontWeight.w700,
                            color: AppColor.title,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        Text("Bio",
                          style: TextStyle(
                            fontSize: context.text12,
                            color: AppColor.title,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text("${item.message}",
                          style: TextStyle(
                            fontSize: context.text12,
                            color: AppColor.subtitle,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                      ],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("${service.serviceName}",
                    style: TextStyle(
                      fontSize: context.text12,
                      fontWeight: FontWeight.w700,
                      color: AppColor.title,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),

        Positioned(
          top: 10,
          right: 20,
          bottom: 20,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(Icons.more_vert),
              Text(
                item.createdAt.toString().substring(0, 10),
                style: const TextStyle(fontSize: 11, color: AppColor.subtitle),
              ),
            ],
          ),
        )
      ],
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