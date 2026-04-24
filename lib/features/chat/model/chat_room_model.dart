class ChatRoomModel {
  final int roomId;
  final String serviceName;
  final String serviceImage;
  final String lastMessage;
  final String sellerName;
  final String sellerImage;
  final String updatedAt;

  ChatRoomModel({
    required this.roomId,
    required this.serviceName,
    required this.serviceImage,
    required this.lastMessage,
    required this.sellerName,
    required this.sellerImage,
    required this.updatedAt,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    final service = json['service'] ?? {};
    final profile = service['user_profile'] ?? {};

    return ChatRoomModel(
      roomId: json['room_id'] ?? 0,
      serviceName: service['service_name'] ?? '',
      serviceImage: service['service_image'] ?? '',
      lastMessage: json['last_message'] ?? '',
      sellerName: profile['user_name'] ?? '',
      sellerImage: profile['user_image'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}