import 'package:flutter/material.dart';

// ─── Design Tokens ─────────────────────────────────────────────────────────────
class _C {
  static const primary     = Color(0xFF0D6E6E);
  static const primaryDark = Color(0xFF094F4F);
  static const accent      = Color(0xFFFFB347);
  static const surface     = Color(0xFFF4F7F7);
  static const card        = Color(0xFFFFFFFF);
  static const textDark    = Color(0xFF0D1F1F);
  static const textMid     = Color(0xFF4A6565);
  static const textLight   = Color(0xFF8AABAB);
  static const chipBg      = Color(0xFFE6F2F2);
  static const success     = Color(0xFF2ECC8A);
}

// ─── Model ────────────────────────────────────────────────────────────────────
class ChatItem {
  final String image;
  final String serviceName;
  final String amount;
  final bool   isPaid;
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

// ─── Screen ───────────────────────────────────────────────────────────────────
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final buyingChats  = dummyChats.where((e) => e.type == "buying").toList();
    final sellingChats = dummyChats.where((e) => e.type == "selling").toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: _C.surface,
        body: Column(
          children: [
            // ── Gradient Header ──────────────────────────────────────────────
            _buildHeader(context),

            // ── Tab Content ──────────────────────────────────────────────────
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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_C.primaryDark, _C.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 14, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Chats",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  // Icon(Icons.search_rounded, color: Colors.white70, size: 24),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Tab bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                labelStyle: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 13),
                unselectedLabelStyle:
                const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
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

            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}

// ─── Chat List ────────────────────────────────────────────────────────────────
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
                  color: _C.chipBg, shape: BoxShape.circle),
              child: const Icon(Icons.chat_bubble_outline_rounded,
                  size: 44, color: _C.primary),
            ),
            const SizedBox(height: 16),
            const Text("No chats here",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: _C.textDark)),
            const SizedBox(height: 6),
            const Text("Your conversations will appear here",
                style: TextStyle(fontSize: 13, color: _C.textMid)),
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

// ─── Chat Card ────────────────────────────────────────────────────────────────
class ChatServiceCard extends StatelessWidget {
  final ChatItem chat;
  const ChatServiceCard({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    final bool isSelling = chat.type == "selling";
    final bool isFree    = !chat.isPaid;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _C.primary.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {}, // Navigator.push(...)
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Thumbnail ────────────────────────────────────────────────
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: chat.image.isNotEmpty
                      ? Image.network(
                    chat.image,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                  )
                      : Container(
                    width: 72,
                    height: 72,
                    color: _C.chipBg,
                    child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: _C.textLight,
                        size: 28),
                  ),
                ),

                const SizedBox(width: 12),

                // ── Content ──────────────────────────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Service name + time
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              chat.serviceName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: _C.textDark,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            chat.time,
                            style: const TextStyle(
                                fontSize: 11, color: _C.textLight),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      // Last message
                      Text(
                        chat.lastMessage,
                        style: const TextStyle(
                            fontSize: 12,
                            color: _C.textMid,
                            height: 1.4),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 10),

                      // Badges row
                      Row(
                        children: [
                          // Amount pill
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isFree
                                  ? _C.success.withOpacity(0.12)
                                  : _C.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isFree ? "Free" : "₹${chat.amount}",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                                color: isFree ? _C.success : _C.primary,
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          // Type badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isSelling
                                  ? _C.accent.withOpacity(0.15)
                                  : _C.chipBg,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isSelling ? "Selling" : "Buying",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                                color: isSelling ? _C.accent : _C.primary,
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
          ),
        ),
      ),
    );
  }
}