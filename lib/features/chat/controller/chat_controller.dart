// lib/feature/chat/controller/chat_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/helper/auth_preferences.dart';
import '../model/chat_message_model.dart';
import '../model/chat_room_model.dart';
import '../repository/chat_repository.dart';

class ChatController extends GetxController {
  final ChatRepository repository = ChatRepository();

  RxList<ChatRoomModel> roomList = <ChatRoomModel>[].obs;
  RxList<ChatMessageModel> messageList = <ChatMessageModel>[].obs;

  RxBool isLoading = false.obs;

  TextEditingController messageController = TextEditingController();

  int currentUserId = 0;

  @override
  void onInit() {
    super.onInit();
    currentUserId = AuthPreferences.getUserId() ?? 0;
    fetchRooms();
  }

  Future<void> fetchRooms() async {
    try {
      isLoading.value = true;
      final data = await repository.getRooms(currentUserId);
      roomList.assignAll(data);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMessages(int roomId) async {
    try {
      isLoading.value = true;
      final data = await repository.getMessages(roomId);
      messageList.assignAll(data);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendFirstMessage({
    required int serviceId,
    required String text,
  }) async {
    await repository.createRoom(
      serviceId: serviceId,
      buyerId: currentUserId,
      message: text,
    );

    fetchRooms();
  }

  void sendLocalMessage() {
    if (messageController.text.trim().isEmpty) return;

    messageList.add(
      ChatMessageModel(
        id: 0,
        senderId: currentUserId,
        senderPhone: "",
        message: messageController.text.trim(),
        isSeen: false,
        isDelivered: true,
        createdAt: DateTime.now().toString(),
      ),
    );

    messageController.clear();
  }
}