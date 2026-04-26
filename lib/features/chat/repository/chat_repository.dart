import '../../../core/network/api_client.dart';
import '../../auth/helper/auth_preferences.dart';
import '../model/chat_message_model.dart';
import '../model/chat_room_create_model.dart';
import '../model/chat_room_list_model.dart';

class ChatRepository {

  static Future<ChatRoomCreateModel?> createRoom({
    required int serviceId,
    required int buyerId,
    String? message,
  }) async {
    try {
      final response = await ApiClient.dio.post(
        "chat/create-room/",
        data: {
          "service_id": serviceId,
          "buyer_id": buyerId,
          "message": message ?? "",
        },
      );

      return ChatRoomCreateModel.fromJson(response.data);
    } catch (e) {
      print("createRoom error: $e");
      return null;
    }
  }

  static Future<List<ChatRoomListModel>> getRooms() async {
    try {
      final userId = AuthPreferences.getUserId();

      final response = await ApiClient.dio.get(
        "chat/rooms/$userId/",
      );

      return (response.data as List)
          .map((e) => ChatRoomListModel.fromJson(e))
          .toList();

    } catch (e) {
      print("getRooms error: $e");
      return [];
    }
  }

  static Future<ChatHistoryResponse?> getHistory(int roomId) async {
    try {
      final response = await ApiClient.dio.get(
        "chat/history/$roomId/",
      );

      return ChatHistoryResponse.fromJson(response.data);

    } catch (e) {
      print("getHistory error: $e");
      return null;
    }
  }

  static Future<String> bulkDelete(List<int> roomIds) async {
    try {
      final response = await ApiClient.dio.delete(
        "chat/delete-bulk/",
        data: {
          "room_ids": roomIds,
        },
      );

      return response.data["message"] ?? "deleted";

    } catch (e) {
      print("bulkDelete error: $e");
      return "error";
    }
  }
}