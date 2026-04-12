class ChatModel {
  final int id;
  final String message;
  final String status;
  final int buyer;
  final int seller;
  final String createdAt;

  ChatModel({
    required this.id,
    required this.message,
    required this.status,
    required this.buyer,
    required this.seller,
    required this.createdAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      message: json['message'] ?? "",
      status: json['status'] ?? "",
      buyer: json['buyer'],
      seller: json['seller'],
      createdAt: json['created_at'] ?? "",
    );
  }
}