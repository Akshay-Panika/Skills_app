import 'package:flutter/material.dart';
import 'package:skills_app/core/constant/app_color.dart';
import 'package:skills_app/core/constant/app_size.dart';
import 'package:skills_app/core/widget/app_card.dart';
import 'package:skills_app/core/widget/my_appbar.dart';

class ChatItem {
  final String image;
  final String serviceName;
  final String amount;
  final bool isPaid;
  final String lastMessage;
  final String time;
  final String type; // buying | selling

  ChatItem({
    required this.image,
    required this.serviceName,
    required this.amount,
    required this.isPaid,
    required this.lastMessage,
    required this.time,
    required this.type,
  });
}

final List<ChatItem> dummyChats = [
  ChatItem(
    image: "",
    serviceName: "Flutter App Development",
    amount: "1500",
    isPaid: true,
    lastMessage: "Project completed 👍",
    time: "2:30 PM",
    type: "selling",
  ),
  ChatItem(
    image: "",
    serviceName: "Logo Design",
    amount: "500",
    isPaid: false,
    lastMessage: "Can you share details?",
    time: "1:10 PM",
    type: "buying",
  ),
  ChatItem(
    image: "",
    serviceName: "UI UX Consultation",
    amount: "800",
    isPaid: true,
    lastMessage: "Meeting at 6 pm",
    time: "Yesterday",
    type: "selling",
  ),
  ChatItem(
    image: "",
    serviceName: "Fitness Coaching",
    amount: "1200",
    isPaid: false,
    lastMessage: "Trial session booked",
    time: "Mon",
    type: "buying",
  ),
];

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final buyingChats = dummyChats.where((e) => e.type == "buying").toList();
    final sellingChats = dummyChats.where((e) => e.type == "selling").toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColor.surface,
        appBar: myAppBar(
            title: 'Chats',
            showBackButton: false,
            titleColor: AppColor.white,
            backgroundColor: AppColor.primary
        ),
        body: Column(
          children: [
            _buildHeader(context),

            Expanded(
              child: TabBarView(
                children: [
                  _ChatList(chats: dummyChats),
                  _ChatList(chats: sellingChats),
                  _ChatList(chats: buyingChats),
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
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color:Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle:  TextStyle(fontWeight: FontWeight.w700, fontSize: context.text12),
          unselectedLabelStyle:
          TextStyle(fontWeight: FontWeight.w500, fontSize: context.text12),
          indicator: BoxDecoration(
            color: Colors.white.withOpacity(0.22),
            borderRadius: BorderRadius.circular(10),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          tabs: const [
            Tab(text: "All"),
            Tab(text: "Selling"),
            Tab(text: "Buying"),
          ],
        ),
      ),
    );
  }
}

class _ChatList extends StatelessWidget {
  final List<ChatItem> chats;
  const _ChatList({required this.chats});

  @override
  Widget build(BuildContext context) {
    if (chats.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                  color: AppColor.surface, shape: BoxShape.circle),
              child: const Icon(Icons.chat_bubble_outline_rounded,
                  size: 44, color: AppColor.primary),
            ),
            const SizedBox(height: 16),
            const Text("No chats here",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColor.title)),
            const SizedBox(height: 6),
            const Text("Your conversations will appear here",
                style: TextStyle(fontSize: 13, color: AppColor.subtitle)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 20),
      itemCount: chats.length,
      itemBuilder: (_, i) => ChatServiceCard(chat: chats[i]),
    );
  }
}

class ChatServiceCard extends StatelessWidget {
  final ChatItem chat;
  const ChatServiceCard({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    final bool isSelling = chat.type == "selling";
    final bool isFree = !chat.isPaid;

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      hasBorder: true,
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCard(
            width:  context.sHeight*0.1,
            height:  context.sHeight*0.1,
            margin: EdgeInsets.zero,
            color: AppColor.surface,
            child: Icon(
                Icons.image_not_supported_outlined,
                color: Colors.grey,
                size: context.sHeight*0.03),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        chat.serviceName,
                        style:  TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: context.text14,
                          color: AppColor.title,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      chat.time,
                      style:  TextStyle(
                          fontSize: context.text12,
                          color: AppColor.subtitle),
                    ),
                  ],
                ),
                const SizedBox(height: 5),

                // Last message
                Text(
                  chat.lastMessage,
                  style:  TextStyle(
                      fontSize: context.text12,
                      color: AppColor.subtitle,
                      height: 1.4),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),

                // Badges row
                Row(
                  spacing: 10,
                  children: [
                    AppCard(
                      margin: EdgeInsets.zero,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      color: isFree ? AppColor.success
                          : AppColor.primary,
                      child: Text(
                        isFree ? "Free" : "₹${chat.amount}",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: context.text10,
                          color: isFree ? AppColor.white : AppColor.white,
                        ),
                      ),
                    ),


                    // Type badge
                    AppCard(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      color: isSelling
                          ? AppColor.secondary
                          : AppColor.surface,
                      margin: EdgeInsets.zero,
                      child: Text(
                        isSelling ? "Selling" : "Buying",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: context.text10,
                          color: isSelling ? AppColor.white : AppColor.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}