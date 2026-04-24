import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/helper/auth_preferences.dart';
import '../model/chat_message_model.dart';
import '../model/chat_room_model.dart';
import '../repository/chat_repository.dart';
import '../service/chat_socket_service.dart';

class ChatController extends GetxController {
  final ChatRepository repository = ChatRepository();
  final ChatSocketService socketService = ChatSocketService();

  RxList<ChatRoomModel> roomList = <ChatRoomModel>[].obs;
  RxList<ChatMessageModel> messageList = <ChatMessageModel>[].obs;

  RxBool isLoading = false.obs;

  TextEditingController messageController = TextEditingController();

  int currentUserId = 0;
  int? currentRoomId;

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

      currentRoomId = roomId;

      final data = await repository.getMessages(roomId);
      messageList.assignAll(data);

      _connectSocket(roomId);
    } finally {
      isLoading.value = false;
    }
  }

  void _connectSocket(int roomId) {
    socketService.disconnect();

    socketService.connect(
      roomId: roomId,
      userId: currentUserId,
    );

    socketService.stream.listen((event) {
      try {
        final data = jsonDecode(event);

        if (data["type"] == "message") {
          messageList.insert(
            0,
            ChatMessageModel(
              id: data["id"] ?? 0,
              senderId: data["sender_id"] ?? 0,
              senderPhone: "",
              message: data["message"] ?? "",
              isSeen: false,
              isDelivered: true,
              createdAt: DateTime.now().toString(),
            ),
          );

          _updateRoom(data["message"] ?? "");
        }
      } catch (e) {
        print("Socket error: $e");
      }
    });
  }

  void _updateRoom(String msg) {
    if (currentRoomId == null) return;

    final index =
    roomList.indexWhere((r) => r.roomId == currentRoomId);

    if (index != -1) {
      final old = roomList[index];

      roomList[index] = ChatRoomModel(
        roomId: old.roomId,
        buyerId: old.buyerId,
        sellerId: old.sellerId,
        serviceName: old.serviceName,
        serviceImage: old.serviceImage,
        sellerName: old.sellerName,
        sellerImage: old.sellerImage,
        lastMessage: msg,
        updatedAt: DateTime.now().toString(),
      );
    }
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;
    final now = DateTime.now().toString();


    // UI instant
    messageList.add(
      ChatMessageModel(
        id: 0,
        senderId: currentUserId,
        senderPhone: "",
        message: text,
        isSeen: false,
        isDelivered: true,
        createdAt: now,
      ),
    );
    socketService.sendMessage(
      senderId: currentUserId,
      message: text,
    );

    messageController.clear();
    // fetchRooms();
    _updateRoom(text);

  }

  @override
  void onClose() {
    socketService.disconnect();
    messageController.dispose();
    super.onClose();
  }
}