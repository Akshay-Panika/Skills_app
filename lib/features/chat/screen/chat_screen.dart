import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/app_color.dart';

class Message {
  final String text;
  final bool isMe;

  Message({required this.text, required this.isMe});
}

class ChatController extends GetxController {
  var messages = <Message>[].obs;
  final textController = TextEditingController();
  final scrollController = ScrollController();

  void sendMessage() {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    messages.add(Message(text: text, isMe: true));
    textController.clear();

    Future.delayed(const Duration(milliseconds: 100), () {
      scrollToBottom();
    });

    // fake reply (remove in real API)
    Future.delayed(const Duration(seconds: 1), () {
      messages.add(Message(text: "Got it 👍", isMe: false));
      scrollToBottom();
    });
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final ChatController controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surface,
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        leading: IconButton(onPressed: () {
          
        }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
        title:  Row(
          children: [
            CircleAvatar(radius: 20),
            SizedBox(width: 10),
            Text("Chat with Seller",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.white),),
          ],
        ),
      ),

      body: Column(
        children: [
          /// CHAT LIST
          Expanded(
            child: Obx(() {
              return ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.all(12),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];

                  return Align(
                    alignment: msg.isMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color: msg.isMe
                            ? AppColor.primary
                            : AppColor.primary.withOpacity(.2),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(14),
                          topRight: const Radius.circular(14),
                          bottomLeft: Radius.circular(msg.isMe ? 14 : 0),
                          bottomRight: Radius.circular(msg.isMe ? 0 : 14),
                        ),
                      ),
                      child: Text(
                        msg.text,
                        style: TextStyle(
                          color: msg.isMe ? Colors.white : Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          /// INPUT BOX
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        color: AppColor.white,
        child: Row(
          children: [

            /// INPUT BOX
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColor.surface,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: AppColor.primary.withOpacity(0.2)),
                ),
                child: TextField(
                  controller: controller.textController,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  minLines: 1,
                  maxLines: 5,
                  style: const TextStyle(color: AppColor.title),
                  decoration: const InputDecoration(
                    hintText: "Type a message...",
                    hintStyle: TextStyle(color: AppColor.subtitle),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8),

            /// SEND BUTTON
            GestureDetector(
              onTap: () {
                controller.sendMessage();
                Future.delayed(const Duration(milliseconds: 100), () {
                  controller.scrollToBottom();
                });
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send,
                  color: AppColor.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }}