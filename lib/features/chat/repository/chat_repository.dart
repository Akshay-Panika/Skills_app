import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../model/chat_model.dart';

class ChatRepository {

  Future<List<ChatModel>> getChats({
    required int serviceId,
    required int userId,
  }) async {
    try {
      final response = await ApiClient.dio.get(
        "booking/service-user/",
        queryParameters: {
          "service_id": serviceId,
          "user_id": userId,
        },
      );

      if (response.data["success"]) {
        final List data = response.data["data"];
        return data.map((e) => ChatModel.fromJson(e)).toList();
      }

      return [];
    } catch (e) {
      throw Exception("Failed to fetch chats");
    }
  }
}