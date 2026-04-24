// lib/feature/chat/screen/room_list_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/chat_controller.dart';
import 'ChatPage.dart';

class RoomListScreen extends StatelessWidget {
  RoomListScreen({super.key});

  final ChatController controller =
  Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.roomList.isEmpty) {
          return const Center(
            child: Text(
              "No Chats Found",
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.roomList.length,
          itemBuilder: (context, index) {
            final room = controller.roomList[index];

            return ListTile(
              contentPadding:
              const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(
                  room.sellerImage,
                ),
              ),
              title: Text(
                room.sellerName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                room.lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(
                room.serviceName,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
              onTap: () {
                Get.to(
                      () => RoomHistoryScreen(
                    roomId: room.roomId,
                    title: room.sellerName,
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }
}