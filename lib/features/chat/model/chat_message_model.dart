/// ============================================================
/// chat_message_model.dart
/// ============================================================

class ChatHistoryResponse {
  final int roomId;
  final List<ChatMessageModel> messages;

  ChatHistoryResponse({
    required this.roomId,
    required this.messages,
  });

  factory ChatHistoryResponse.fromJson(Map<String, dynamic> json) {
    return ChatHistoryResponse(
      roomId: json["room_id"] ?? 0,
      messages: (json["messages"] as List? ?? [])
          .map((e) => ChatMessageModel.fromJson(e))
          .toList(),
    );
  }
}

class ChatMessageModel {
  final int id;
  final int room;
  final int sender;
  final String senderPhone;
  final String message;
  final bool isSeen;
  final String createdAt;

  ChatMessageModel({
    required this.id,
    required this.room,
    required this.sender,
    required this.senderPhone,
    required this.message,
    required this.isSeen,
    required this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json["id"] ?? 0,
      room: json["room"] ?? 0,
      sender: json["sender"] ?? 0,
      senderPhone: json["sender_phone"] ?? "",
      message: json["message"] ?? "",
      isSeen: json["is_seen"] ?? false,
      createdAt: json["created_at"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "room": room,
      "sender": sender,
      "sender_phone": senderPhone,
      "message": message,
      "is_seen": isSeen,
      "created_at": createdAt,
    };
  }
}