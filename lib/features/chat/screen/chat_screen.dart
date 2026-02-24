import 'package:flutter/material.dart';

import 'chating_screen.dart';

/// ================= MODEL =================
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

/// ================= DUMMY DATA =================
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

/// ================= MAIN SCREEN =================
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final buyingChats =
    dummyChats.where((e) => e.type == "buying").toList();

    final sellingChats =
    dummyChats.where((e) => e.type == "selling").toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xffF7F8FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Chat'),
          actions: [
            // IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.blueAccent,
            labelColor: Colors.black,
            tabs: [
              Tab(text: "All"),
              Tab(text: "Buying"),
              Tab(text: "Selling"),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            /// ALL
            ListView.builder(
              itemCount: dummyChats.length,
              itemBuilder: (_, i) {
                final chat = dummyChats[i];
                return ChatServiceCard(chat: chat);
              },
            ),

            /// BUYING
            ListView.builder(
              itemCount: buyingChats.length,
              itemBuilder: (_, i) {
                final chat = buyingChats[i];
                return ChatServiceCard(chat: chat);
              },
            ),

            /// SELLING
            ListView.builder(
              itemCount: sellingChats.length,
              itemBuilder: (_, i) {
                final chat = sellingChats[i];
                return ChatServiceCard(chat: chat);
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// ================= CHAT CARD =================
class ChatServiceCard extends StatelessWidget {
  final ChatItem chat;

  const ChatServiceCard({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 8,
          )
        ],
      ),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatingScreen(),)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// THUMBNAIL
            Container(
              width: 110,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.withOpacity(0.15),
              ),
              child: const Icon(Icons.image, color: Colors.lightBlueAccent),
            ),
        
            const SizedBox(width: 12),
        
            /// TEXT CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.serviceName,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14),
                  ),
        
                  const SizedBox(height: 4),
        
                  Text(
                    chat.lastMessage,
                    style: TextStyle(
                        color: Colors.grey.shade600, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
        
                  const SizedBox(height: 6),
        
                  Row(
                    children: [
                      Text(
                        "₹ ${chat.amount}",
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13),
                      ),
        
                      const SizedBox(width: 8),
        
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: chat.isPaid
                              ? Colors.green.withOpacity(.12)
                              : Colors.orange.withOpacity(.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          chat.isPaid ? "Paid" : "Unpaid",
                          style: TextStyle(
                            color: chat.isPaid
                                ? Colors.green
                                : Colors.orange,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Text(
              chat.time,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}