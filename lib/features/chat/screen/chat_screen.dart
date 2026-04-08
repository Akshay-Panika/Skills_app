import 'package:flutter/material.dart';
import 'package:skills_app/core/constant/app_color.dart';
import 'package:skills_app/core/constant/app_size.dart';
import 'package:skills_app/core/widget/app_card.dart';
import 'package:skills_app/core/widget/my_appbar.dart';

class ChatItem {
  final String image;
  final String userName;
  final String serviceName;
  final String lastMessage;
  final String time;
  final String type; // buying | selling
  final bool hasUnread;

  ChatItem({
    required this.image,
    required this.userName,
    required this.serviceName,
    required this.lastMessage,
    required this.time,
    required this.type,
    this.hasUnread = false,
  });
}

final List<ChatItem> dummyChats = [
  ChatItem(
    image: "https://i.pravatar.cc/150?img=1",
    userName: "Rohan S.",
    serviceName: "Guitar Classes",
    lastMessage: "Hi, I saw your guitar teaching ad, still available?",
    time: "10:30 am",
    type: "buying",
    hasUnread: true,
  ),
  ChatItem(
    image: "https://i.pravatar.cc/150?img=2",
    userName: "Priya M.",
    serviceName: "Yoga Training",
    lastMessage: "What are your batch timings?",
    time: "Yesterday",
    type: "selling",
  ),
  ChatItem(
    image: "https://i.pravatar.cc/150?img=3",
    userName: "Amit K.",
    serviceName: "Web Development Course",
    lastMessage: "Do you teach React as well?",
    time: "Mon",
    type: "buying",
  ),
  ChatItem(
    image: "https://i.pravatar.cc/150?img=4",
    userName: "Sneha R.",
    serviceName: "Spoken English Classes",
    lastMessage: "Is online session available?",
    time: "Sun",
    type: "selling",
  ),
  ChatItem(
    image: "https://i.pravatar.cc/150?img=5",
    userName: "Vikas T.",
    serviceName: "Drawing & Painting",
    lastMessage: "My daughter is 8 years old, can she join?",
    time: "Sat",
    type: "buying",
    hasUnread: true,
  ),
  ChatItem(
    image: "https://i.pravatar.cc/150?img=6",
    userName: "Neha D.",
    serviceName: "Dance Classes - Bharatnatyam",
    lastMessage: "What is the monthly fee?",
    time: "Fri",
    type: "selling",
  ),
];
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['All', 'Unread', 'Important', 'Elite Buyer', 'Elite Seller'];

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
          backgroundColor: AppColor.primary,
          actions: [
          ],
        ),
        body: Column(
          children: [
            _buildTabBar(context),
            _PromoBanner(),
            Expanded(
              child: TabBarView(
                children: [
                  _ChatTabContent(
                    chats: dummyChats,
                    filters: _filters,
                    selectedFilter: _selectedFilter,
                    onFilterChanged: (i) => setState(() => _selectedFilter = i),
                  ),
                  _ChatTabContent(
                    chats: sellingChats,
                    filters: _filters,
                    selectedFilter: _selectedFilter,
                    onFilterChanged: (i) => setState(() => _selectedFilter = i),
                  ),
                  _ChatTabContent(
                    chats: buyingChats,
                    filters: _filters,
                    selectedFilter: _selectedFilter,
                    onFilterChanged: (i) => setState(() => _selectedFilter = i),
                  ),
                ],
              ),
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
        labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: context.text12),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: context.text12),
        indicatorColor: Colors.white,
        indicatorWeight: 2.5,
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
  final List<ChatItem> chats;
  final List<String> filters;
  final int selectedFilter;
  final ValueChanged<int> onFilterChanged;

  const _ChatTabContent({
    required this.chats,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [

        _QuickFilters(
          filters: filters,
          selectedIndex: selectedFilter,
          onTap: onFilterChanged,
        ),
        if (chats.isEmpty)
          _EmptyState()
        else
          ...chats.map((chat) => ChatSkillCard(chat: chat)),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _PromoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      padding: const EdgeInsets.all(12),
      color: AppColor.primary.withOpacity(0.1),
      child: Row(
        children: [
          AppCard(
            width: 48,
            height: 48,
            color: AppColor.primary,
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("👑", style: TextStyle(fontSize: 14)),
                Text("ELITE", style: TextStyle(fontSize: 6, color: Colors.white, fontWeight: FontWeight.w700)),
                Text("BUYER", style: TextStyle(fontSize: 6, color: Colors.white, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Serious about buying?",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColor.title)),
                SizedBox(height: 2),
                Text("Unlock Contact of Owners",
                    style: TextStyle(fontSize: 11, color: AppColor.subtitle)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Buy Now"),
          ),
        ],
      ),
    );
  }
}

class _QuickFilters extends StatelessWidget {
  final List<String> filters;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _QuickFilters({
    required this.filters,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(14, 8, 14, 4),
          child: Text("QUICK FILTERS",
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                  color: AppColor.subtitle, letterSpacing: 0.8)),
        ),
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final isActive = i == selectedIndex;
              return AppCard(
                onTap: () => onTap(i),
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                child: Center(
                  child: Text(
                    filters[i],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      color: isActive ? AppColor.primary : AppColor.subtitle,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90, height: 90,
              decoration: const BoxDecoration(color: AppColor.surface, shape: BoxShape.circle),
              child: const Icon(Icons.chat_bubble_outline_rounded, size: 44, color: AppColor.primary),
            ),
            const SizedBox(height: 16),
            const Text("No chats here",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColor.title)),
            const SizedBox(height: 6),
            const Text("Your conversations will appear here",
                style: TextStyle(fontSize: 13, color: AppColor.subtitle)),
          ],
        ),
      ),
    );
  }
}

class ChatSkillCard extends StatelessWidget {
  final ChatItem chat;
  const ChatSkillCard({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppCard(
          margin: const EdgeInsets.only(bottom: 10, left: 10,right: 10),
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: chat.image.isNotEmpty
                        ? Image.network(
                      chat.image,
                      width: context.sHeight*0.1,
                      height: context.sHeight*0.1,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          _placeholder(context),
                    )
                        : _placeholder(context),
                  ),
                  if (chat.hasUnread)
                    Positioned(
                      bottom: -2, right: -2,
                      child: Container(
                        width: 14, height: 14,
                        decoration: BoxDecoration(
                          color: AppColor.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(chat.userName,
                        style:  TextStyle(
                            fontSize: context.text14, fontWeight: FontWeight.w700, color: AppColor.title),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text(chat.serviceName,
                        style:  TextStyle(fontSize: context.text14, color: AppColor.subtitle),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.done_all, size: 13, color: Color(0xFF9CA3AF)),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(chat.lastMessage,
                              style:  TextStyle(fontSize: context.text12, color: Color(0xFF9CA3AF)),
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
        Positioned(
          top: 0,right: 0,bottom: 16,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: () {

              }, icon: Icon(Icons.more_vert)),
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: Text(chat.time,
                    style: const TextStyle(fontSize: 11, color: AppColor.subtitle)),
              ),
            ],
          ),
        )
      ],
    );
  }
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