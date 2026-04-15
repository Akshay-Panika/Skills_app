class ServiceListModel {
  final int id;
  final String serviceImage;
  final String? serviceAmount;
  final String serviceName;
  final bool serviceStatus;
  final bool swipeStatus;
  final bool isFavorite;
  final String serviceDescription;
  final double? latitude;
  final double? longitude;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int category;
  final int subcategory;
  final UserProfileModel? userProfile;
  final String? distance;

  ServiceListModel({
    required this.id,
    required this.serviceImage,
    this.serviceAmount,
    required this.serviceName,
    required this.serviceStatus,
    required this.swipeStatus,
    required this.isFavorite,
    required this.serviceDescription,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
    required this.category,
    required this.subcategory,
    this.userProfile,
    this.distance,
  });

  factory ServiceListModel.fromJson(Map<String, dynamic> json) {
    return ServiceListModel(
      id: json['id'] ?? 0,
      serviceImage: json['service_image'] ?? "",
      serviceAmount: json['service_amount']?.toString(),
      serviceName: json['service_name'] ?? "",
      serviceStatus: json['service_status'] ?? false,
      swipeStatus: json['swipe_status'] ?? false,
      isFavorite: json['is_favorite'] ?? false,
      serviceDescription: json['service_description'] ?? "",

      latitude: (json['latitude'] != null)
          ? (json['latitude'] as num).toDouble()
          : null,

      longitude: (json['longitude'] != null)
          ? (json['longitude'] as num).toDouble()
          : null,

      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,

      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,

      category: json['category'] ?? 0,
      subcategory: json['subcategory'] ?? 0,

      userProfile: json['user_profile'] != null
          ? UserProfileModel.fromJson(json['user_profile'])
          : null,

      distance: json['distance']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "service_image": serviceImage,
      "service_amount": serviceAmount,
      "service_name": serviceName,
      "service_status": serviceStatus,
      "swipe_status": swipeStatus,
      "is_favorite": isFavorite,
      "service_description": serviceDescription,
      "latitude": latitude,
      "longitude": longitude,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
      "category": category,
      "subcategory": subcategory,
      "user_profile": userProfile?.toJson(),
      "distance": distance,
    };
  }
  ServiceListModel copyWith({
    bool? isFavorite,
  }) {
    return ServiceListModel(
      id: id,
      serviceImage: serviceImage,
      serviceAmount: serviceAmount,
      serviceName: serviceName,
      serviceStatus: serviceStatus,
      swipeStatus: swipeStatus,
      isFavorite: isFavorite ?? this.isFavorite,
      serviceDescription: serviceDescription,
      latitude: latitude,
      longitude: longitude,
      createdAt: createdAt,
      updatedAt: updatedAt,
      category: category,
      subcategory: subcategory,
      userProfile: userProfile,
      distance: distance,
    );
  }
}

class ServiceListResponse {
  final int count;
  final List<ServiceListModel> services;

  ServiceListResponse({
    required this.count,
    required this.services,
  });

  factory ServiceListResponse.fromJson(Map<String, dynamic> json) {
    return ServiceListResponse(
      count: json['count'] ?? 0,
      services: (json['services'] as List? ?? [])
          .map((e) => ServiceListModel.fromJson(e))
          .toList(),
    );
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
  final DateTime? createdAt;
  final int user;

  UserProfileModel({
    required this.id,
    required this.userPhone,
    required this.userName,
    required this.userEmail,
    required this.userGender,
    required this.userBio,
    this.userImage,
    this.createdAt,
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

      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,

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
      "created_at": createdAt?.toIso8601String(),
      "user": user,
    };
  }
}