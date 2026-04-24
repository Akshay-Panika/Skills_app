class ChatRoomModel {
  final int roomId;

  final int buyerId;
  final int sellerId;

  final String serviceName;
  final String serviceImage;

  final String lastMessage;
  final String updatedAt;

  final String sellerName;
  final String sellerImage;

  ChatRoomModel({
    required this.roomId,
    required this.buyerId,
    required this.sellerId,
    required this.serviceName,
    required this.serviceImage,
    required this.lastMessage,
    required this.updatedAt,
    required this.sellerName,
    required this.sellerImage,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    final service = json['service'] ?? {};
    final profile = service['user_profile'] ?? {};

    return ChatRoomModel(
      roomId: json['room_id'] ?? 0,
      buyerId: json['buyer_id'] ?? 0,
      sellerId: json['seller_id'] ?? 0,

      serviceName: service['service_name'] ?? '',
      serviceImage: service['service_image'] ?? '',

      lastMessage: json['last_message'] ?? '',
      updatedAt: json['updated_at'] ?? '',

      sellerName: profile['user_name'] ?? '',
      sellerImage: profile['user_image'] ?? '',
    );
  }
}