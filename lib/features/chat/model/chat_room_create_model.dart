
class ChatRoomCreateModel {
  final int roomId;
  final bool created;
  final String lastMessage;

  ChatRoomCreateModel({
    required this.roomId,
    required this.created,
    required this.lastMessage,
  });

  factory ChatRoomCreateModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomCreateModel(
      roomId: json["room_id"] ?? 0,
      created: json["created"] ?? false,
      lastMessage: json["last_message"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "room_id": roomId,
      "created": created,
      "last_message": lastMessage,
    };
  }
}