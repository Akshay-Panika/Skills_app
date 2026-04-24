// issue:
// initState() ke andar direct controller.fetchMessages(widget.roomId)
// call ho raha hai, aur uske andar Rx value update ho rahi hai,
// isliye "setState() or markNeedsBuild() called during build" aa raha hai.

// fix:
// WidgetsBinding.instance.addPostFrameCallback use karo

// final fixed code:

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/chat_controller.dart';

class RoomHistoryScreen extends StatefulWidget {
  final int roomId;
  final String title;

  const RoomHistoryScreen({
    super.key,
    required this.roomId,
    required this.title,
  });

  @override
  State<RoomHistoryScreen> createState() =>
      _RoomHistoryScreenState();
}

class _RoomHistoryScreenState
    extends State<RoomHistoryScreen> {
  final ChatController controller =
  Get.find<ChatController>();

  @override
  void initState() {
    super.initState();

    /// FIX HERE
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchMessages(widget.roomId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.messageList.isEmpty) {
                return const Center(
                  child: Text("No messages yet"),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: controller.messageList.length,
                itemBuilder: (context, index) {
                  final msg =
                  controller.messageList[index];

                  final isMe =
                      msg.senderId ==
                          controller.currentUserId;

                  return MessageBubble(
                    message: msg.message,
                    isMe: isMe,
                  );
                },
              );
            }),
          ),

          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller:
                    controller.messageController,
                    decoration: InputDecoration(
                      hintText: "Type message...",
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                InkWell(
                  onTap: () {
                    controller.sendLocalMessage();
                  },
                  child: Container(
                    padding:
                    const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 10,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        constraints: const BoxConstraints(
          maxWidth: 280,
        ),
        decoration: BoxDecoration(
          color: isMe
              ? Colors.blue
              : Colors.grey.shade200,
          borderRadius:
          BorderRadius.circular(14),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isMe
                ? Colors.white
                : Colors.black,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}