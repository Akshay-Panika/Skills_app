class ChatMessageModel {
  final int id;
  final int senderId;
  final String senderPhone;
  final String message;
  final bool isSeen;
  final bool isDelivered;
  final String createdAt;

  ChatMessageModel({
    required this.id,
    required this.senderId,
    required this.senderPhone,
    required this.message,
    required this.isSeen,
    required this.isDelivered,
    required this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] ?? 0,
      senderId: json['sender'] ?? 0,
      senderPhone: json['sender_phone'] ?? '',
      message: json['message'] ?? '',
      isSeen: json['is_seen'] ?? false,
      isDelivered: json['is_delivered'] ?? false,
      createdAt: json['created_at'] ?? '',
    );
  }
}