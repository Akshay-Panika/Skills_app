class ChatModel {
  final int id;
  final String message;
  final String status;
  final int buyer;
  final int seller;
  final String createdAt;
  final String updatedAt;

  // ✅ NEW (service added)
  final ServiceModel? service;

  ChatModel({
    required this.id,
    required this.message,
    required this.status,
    required this.buyer,
    required this.seller,
    required this.createdAt,
    required this.updatedAt,
    this.service,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] ?? 0,
      message: json['message'] ?? "",
      status: json['status'] ?? "",
      buyer: json['buyer'] ?? 0,
      seller: json['seller'] ?? 0,
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",

      // ✅ SAFE PARSE
      service: json['service'] != null
          ? ServiceModel.fromJson(json['service'])
          : null,
    );
  }
}

class ServiceModel {
  final int id;
  final String serviceImage;
  final String? serviceAmount;
  final bool swipeStatus;
  final bool isFavorite;
  final String serviceName;
  final bool serviceStatus;
  final String serviceDescription;
  final double? latitude;
  final double? longitude;
  final String createdAt;
  final String updatedAt;
  final int category;
  final int subcategory;

  // ✅ user profile
  final UserProfileModel? userProfile;

  ServiceModel({
    required this.id,
    required this.serviceImage,
    this.serviceAmount,
    required this.swipeStatus,
    required this.isFavorite,
    required this.serviceName,
    required this.serviceStatus,
    required this.serviceDescription,
    this.latitude,
    this.longitude,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
    required this.subcategory,
    this.userProfile,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? 0,
      serviceImage: json['service_image'] ?? "",
      serviceAmount: json['service_amount']?.toString(),
      swipeStatus: json['swipe_status'] ?? false,
      isFavorite: json['is_favorite'] ?? false,
      serviceName: json['service_name'] ?? "",
      serviceStatus: json['service_status'] ?? false,
      serviceDescription: json['service_description'] ?? "",
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      category: json['category'] ?? 0,
      subcategory: json['subcategory'] ?? 0,

      userProfile: json['user_profile'] != null
          ? UserProfileModel.fromJson(json['user_profile'])
          : null,
    );
  }
}
class UserProfileModel {
  final int id;
  final String userName;
  final String userImage;
  final String userPhone;
  final String userEmail;
  final String userGender;
  final String userBio;
  final String createdAt;
  final int user;

  UserProfileModel({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.userPhone,
    required this.userEmail,
    required this.userGender,
    required this.userBio,
    required this.createdAt,
    required this.user,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] ?? 0,
      userName: json['user_name'] ?? "",
      userImage: json['user_image'] ?? "",
      userPhone: json['user_phone'] ?? "",
      userEmail: json['user_email'] ?? "",
      userGender: json['user_gender'] ?? "",
      userBio: json['user_bio'] ?? "",
      createdAt: json['created_at'] ?? "",
      user: json['user'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_name": userName,
      "user_image": userImage,
      "user_phone": userPhone,
      "user_email": userEmail,
      "user_gender": userGender,
      "user_bio": userBio,
      "created_at": createdAt,
      "user": user,
    };
  }
}