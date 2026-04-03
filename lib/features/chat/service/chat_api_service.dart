import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatApiService {
  static const baseUrl = "https://skills-app-service.onrender.com";

  /// ✅ CREATE CHAT ROOM
  static Future<int> createChatRoom({
    required int serviceId,
    required int customerId,
    required int providerId,
  }) async {
    final res = await http.post(
      Uri.parse("$baseUrl/chat/create/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "service_id": serviceId,
        "customer_id": customerId,
        "provider_id": providerId,
      }),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data["chat_room_id"];
    } else {
      throw Exception("Failed to create chat room");
    }
  }

  /// ✅ GET MESSAGES
  static Future<List> getMessages(int chatRoomId) async {
    final res = await http.get(
      Uri.parse("$baseUrl/chat/messages/$chatRoomId/"),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data["messages"];
    } else {
      throw Exception("Failed to load messages");
    }
  }
}