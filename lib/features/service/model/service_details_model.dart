class ServiceDetailsModel {
  final int id;
  final String serviceImage;
  final String? serviceAmount;
  final bool swipeStatus;
  final String serviceName;
  final bool serviceStatus;
  final String serviceDescription;

  final double? latitude;
  final double? longitude;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  final CategoryModel? category;
  final SubcategoryModel? subcategory;

  final UserProfileModel? userProfile;
  final String? distance;

  ServiceDetailsModel({
    required this.id,
    required this.serviceImage,
    this.serviceAmount,
    required this.swipeStatus,
    required this.serviceName,
    required this.serviceStatus,
    required this.serviceDescription,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
    this.category,
    this.subcategory,
    this.userProfile,
    this.distance,
  });

  factory ServiceDetailsModel.fromJson(Map<String, dynamic> json) {
    return ServiceDetailsModel(
      id: json['id'] ?? 0,
      serviceImage: json['service_image'] ?? "",
      serviceAmount: json['service_amount']?.toString(),
      swipeStatus: json['swipe_status'] ?? false,
      serviceName: json['service_name'] ?? "",
      serviceStatus: json['service_status'] ?? false,
      serviceDescription: json['service_description'] ?? "",

      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,

      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,

      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,

      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,

      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,

      subcategory: json['subcategory'] != null
          ? SubcategoryModel.fromJson(json['subcategory'])
          : null,

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
      "swipe_status": swipeStatus,
      "service_name": serviceName,
      "service_status": serviceStatus,
      "service_description": serviceDescription,
      "latitude": latitude,
      "longitude": longitude,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
      "category": category?.toJson(),
      "subcategory": subcategory?.toJson(),
      "user_profile": userProfile?.toJson(),
      "distance": distance,
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

class CategoryModel {
  final int id;
  final String categoryName;
  final String categoryImage;

  CategoryModel({
    required this.id,
    required this.categoryName,
    required this.categoryImage,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      categoryName: json['category_name'] ?? "",
      categoryImage: json['category_image'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "category_name": categoryName,
      "category_image": categoryImage,
    };
  }
}

class SubcategoryModel {
  final int id;
  final int category;
  final String subcategoryName;
  final String subcategoryImage;
  final String categoryName;

  SubcategoryModel({
    required this.id,
    required this.category,
    required this.subcategoryName,
    required this.subcategoryImage,
    required this.categoryName,
  });

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) {
    return SubcategoryModel(
      id: json['id'] ?? 0,
      category: json['category'] ?? 0,
      subcategoryName: json['subcategory_name'] ?? "",
      subcategoryImage: json['subcategory_image'] ?? "",
      categoryName: json['category_name'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "category": category,
      "subcategory_name": subcategoryName,
      "subcategory_image": subcategoryImage,
      "category_name": categoryName,
    };
  }
}