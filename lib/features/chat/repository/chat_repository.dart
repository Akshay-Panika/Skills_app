// lib/feature/chat/repository/chat_repository.dart

import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../model/chat_message_model.dart';
import '../model/chat_room_model.dart';

class ChatRepository {
  final Dio dio = ApiClient.dio;

  Future<void> createRoom({
    required int serviceId,
    required int buyerId,
    required String message,
  }) async {
    await dio.post(
      "chat/create-room/",
      data: {
        "service_id": serviceId,
        "buyer_id": buyerId,
        "message": message,
      },
    );
  }

  Future<List<ChatRoomModel>> getRooms(int userId) async {
    final response = await dio.get("chat/rooms/$userId/");

    return (response.data as List)
        .map((e) => ChatRoomModel.fromJson(e))
        .toList();
  }

  Future<List<ChatMessageModel>> getMessages(int roomId) async {
    final response = await dio.get("chat/history/$roomId/");

    final messages = response.data["messages"] as List;

    return messages
        .map((e) => ChatMessageModel.fromJson(e))
        .toList();
  }
}