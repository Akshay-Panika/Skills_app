class ServiceListModel {
  final int id;
  final String distance;
  final String serviceImage;
  final String? serviceAmount;
  final bool swipeStatus;
  final bool isFavorite;

  final UserProfileModel? userProfile;
  final CategoryModel? category;
  final SubcategoryModel? subcategory;

  final String serviceName;
  final bool serviceStatus;
  final String serviceDescription;

  final double? latitude;
  final double? longitude;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  ServiceListModel({
    required this.id,
    required this.distance,
    required this.serviceImage,
    this.serviceAmount,
    required this.swipeStatus,
    required this.isFavorite,
    this.userProfile,
    this.category,
    this.subcategory,
    required this.serviceName,
    required this.serviceStatus,
    required this.serviceDescription,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
  });

  factory ServiceListModel.fromJson(Map<String, dynamic> json) {
    return ServiceListModel(
      id: json['id'] ?? 0,
      distance: json['distance'] ?? "",

      serviceImage: json['service_image'] ?? "",
      serviceAmount: json['service_amount']?.toString(),

      swipeStatus: json['swipe_status'] ?? false,
      isFavorite: json['is_favorite'] ?? false,

      userProfile: json['user_profile'] != null
          ? UserProfileModel.fromJson(json['user_profile'])
          : null,

      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,

      subcategory: json['subcategory'] != null
          ? SubcategoryModel.fromJson(json['subcategory'])
          : null,

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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "distance": distance,
      "service_image": serviceImage,
      "service_amount": serviceAmount,
      "swipe_status": swipeStatus,
      "is_favorite": isFavorite,
      "user_profile": userProfile?.toJson(),
      "category": category?.toJson(),
      "subcategory": subcategory?.toJson(),
      "service_name": serviceName,
      "service_status": serviceStatus,
      "service_description": serviceDescription,
      "latitude": latitude,
      "longitude": longitude,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
    };
  }

  ServiceListModel copyWith({
    bool? isFavorite,
  }) {
    return ServiceListModel(
      id: id,
      distance: distance,
      serviceImage: serviceImage,
      serviceAmount: serviceAmount,
      swipeStatus: swipeStatus,
      isFavorite: isFavorite ?? this.isFavorite,
      userProfile: userProfile,
      category: category,
      subcategory: subcategory,
      serviceName: serviceName,
      serviceStatus: serviceStatus,
      serviceDescription: serviceDescription,
      latitude: latitude,
      longitude: longitude,
      createdAt: createdAt,
      updatedAt: updatedAt,
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