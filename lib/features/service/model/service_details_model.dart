class ServiceDetailsModel {
  final int id;
  final String serviceImage;
  final String? serviceAmount;
  final bool swipeStatus;
  final String serviceName;
  final bool serviceStatus;
  final String serviceDescription;
  final double latitude;
  final double longitude;
  final String createdAt;
  final String updatedAt;
  final int category;
  final int subcategory;
  final UserProfileModel? userProfile;


  ServiceDetailsModel({
    required this.id,
    required this.serviceImage,
    this.serviceAmount,
    required this.swipeStatus,
    required this.serviceName,
    required this.serviceStatus,
    required this.serviceDescription,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
    required this.subcategory,
    this.userProfile,

  });

  factory ServiceDetailsModel.fromJson(Map<String, dynamic> json) {
    return ServiceDetailsModel(
      id: json['id'] as int,
      serviceImage: json['service_image'] as String,
      serviceAmount: json['service_amount']?.toString(),
      swipeStatus: json['swipe_status'] as bool,
      serviceName: json['service_name'] as String,
      serviceStatus: json['service_status'] as bool,
      serviceDescription: json['service_description'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      category: json['category'] as int,
      subcategory: json['subcategory'] as int,
      userProfile: json['user_profile'] != null
          ? UserProfileModel.fromJson(json['user_profile'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service_image': serviceImage,
      'service_amount': serviceAmount,
      'swipe_status': swipeStatus,
      'service_name': serviceName,
      'service_status': serviceStatus,
      'service_description': serviceDescription,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'category': category,
      'subcategory': subcategory,
      "user_profile": userProfile?.toJson(),
    };
  }
}

class UserProfileModel {
  final int id;
  final String userPhone;
  final String userName;
  final String userEmail;
  final String userGender;
  final String userBio;
  final String? userImage;
  final String createdAt;
  final int user;

  UserProfileModel({
    required this.id,
    required this.userPhone,
    required this.userName,
    required this.userEmail,
    required this.userGender,
    required this.userBio,
    this.userImage,
    required this.createdAt,
    required this.user,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] ?? 0,
      userPhone: json['user_phone'] ?? "",
      userName: json['user_name'] ?? "",
      userEmail: json['user_email'] ?? "",
      userGender: json['user_gender'] ?? "",
      userBio: json['user_bio'] ?? "",
      userImage: json['user_image'],
      createdAt: json['created_at'] ?? "",
      user: json['user'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_phone": userPhone,
      "user_name": userName,
      "user_email": userEmail,
      "user_gender": userGender,
      "user_bio": userBio,
      "user_image": userImage,
      "created_at": createdAt,
      "user": user,
    };
  }
}