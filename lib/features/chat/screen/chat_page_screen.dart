import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skills_app/core/widget/app_card.dart';
import 'package:skills_app/core/widget/app_date_format.dart';
import '../../../core/constant/app_size.dart';
import '../controller/chat_controller.dart';
import 'package:intl/intl.dart';
import '../../../core/constant/app_color.dart';

class ChatPageScreen extends StatefulWidget {
  final int roomId;
  final String title;

  const ChatPageScreen({
    super.key,
    required this.roomId,
    required this.title,
  });

  @override
  State<ChatPageScreen> createState() => _ChatPageScreenState();
}

class _ChatPageScreenState extends State<ChatPageScreen> {
  final ChatController controller = Get.find<ChatController>();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchMessages(widget.roomId);
    });
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surface,

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        elevation: 0,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // ================= BODY =================
      body: Column(
        children: [
          // ================= CHAT LIST =================
          Expanded(
            child: Obx(() {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                scrollToBottom();
              });

              return ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                itemCount: controller.messageList.length,
                itemBuilder: (context, index) {
                  final msg = controller.messageList[index];
                  final isMe = msg.senderId == controller.currentUserId;

                  return Align(
                    alignment:
                    isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),

                      // ================= BUBBLE =================
                      decoration: BoxDecoration(
                        color: isMe
                            ? AppColor.primary
                            : Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(14),
                          topRight: const Radius.circular(14),
                          bottomLeft: Radius.circular(isMe ? 14 : 0),
                          bottomRight: Radius.circular(isMe ? 0 : 14),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 3,
                          )
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            msg.message,
                            style: TextStyle(
                              color: isMe ? Colors.white : AppColor.title,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),

                          Text('${AppDateFormat.format(msg.createdAt)}',
                            style: TextStyle(
                              fontSize: 10,
                              color: isMe
                                  ? Colors.white70
                                  : AppColor.subtitle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          // ================= INPUT BAR =================
          SafeArea(
            child: AppCard(
              hasBorder: true,
              borderRadius: 0,
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: _mxgBox(controller: controller.messageController),
                  ),
            
                  const SizedBox(width: 8),
            
                  // ================= SEND BUTTON =================
                  GestureDetector(
                    onTap: () {
                      controller.sendMessage();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: AppColor.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _mxgBox({
    required TextEditingController controller,
  }){
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColor.primary.withOpacity(.1), width: 1.2),
    );

    return TextField(
      maxLines: 4,
      minLines: 1,
      keyboardType: TextInputType.multiline,
      controller: controller,
      style: GoogleFonts.poppins(color: AppColor.title, fontSize: context.text14),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColor.surface,
        hintText: "Type message...",
        alignLabelWithHint: true,
        contentPadding: const EdgeInsets.all(12),
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        hintStyle: GoogleFonts.poppins(color: AppColor.subtitle, fontSize: context.text14),
      ),
    );
  }
}
