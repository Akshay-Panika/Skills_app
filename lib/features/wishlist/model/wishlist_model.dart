class WishlistResponse {
  final bool success;
  final int count;
  final List<WishlistModel> favorites;

  WishlistResponse({
    required this.success,
    required this.count,
    required this.favorites,
  });

  factory WishlistResponse.fromJson(Map<String, dynamic> json) {
    return WishlistResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      favorites: (json['favorites'] as List? ?? [])
          .map((e) => WishlistModel.fromJson(e))
          .toList(),
    );
  }
}

class WishlistModel {
  final int id;
  final String? distance;
  final String serviceImage;
  final String? serviceAmount;
  final bool swipeStatus;
  final bool isFavorite;

  final String serviceName;
  final bool serviceStatus;
  final String serviceDescription;

  final double? latitude;
  final double? longitude;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  final UserProfile userProfile;
  final Category category;
  final SubCategory subcategory;

  WishlistModel({
    required this.id,
    required this.distance,
    required this.serviceImage,
    required this.serviceAmount,
    required this.swipeStatus,
    required this.isFavorite,
    required this.serviceName,
    required this.serviceStatus,
    required this.serviceDescription,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
    required this.userProfile,
    required this.category,
    required this.subcategory,
  });

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      id: json['id'] ?? 0,
      distance: json['distance']?.toString(),
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
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      userProfile: UserProfile.fromJson(
        json['user_profile'] ?? {},
      ),
      category: Category.fromJson(
        json['category'] ?? {},
      ),
      subcategory: SubCategory.fromJson(
        json['subcategory'] ?? {},
      ),
    );
  }
}

class UserProfile {
  final int id;
  final String userImage;
  final String userPhone;
  final String userName;
  final String userEmail;
  final String userGender;
  final String userBio;
  final DateTime? createdAt;
  final int user;

  UserProfile({
    required this.id,
    required this.userImage,
    required this.userPhone,
    required this.userName,
    required this.userEmail,
    required this.userGender,
    required this.userBio,
    required this.createdAt,
    required this.user,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? 0,
      userImage: json['user_image'] ?? "",
      userPhone: json['user_phone'] ?? "",
      userName: json['user_name'] ?? "",
      userEmail: json['user_email'] ?? "",
      userGender: json['user_gender'] ?? "",
      userBio: json['user_bio'] ?? "",
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      user: json['user'] ?? 0,
    );
  }
}

class Category {
  final int id;
  final String categoryName;
  final String categoryImage;

  Category({
    required this.id,
    required this.categoryName,
    required this.categoryImage,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      categoryName: json['category_name'] ?? "",
      categoryImage: json['category_image'] ?? "",
    );
  }
}

class SubCategory {
  final int id;
  final int category;
  final String subcategoryName;
  final String subcategoryImage;
  final String categoryName;

  SubCategory({
    required this.id,
    required this.category,
    required this.subcategoryName,
    required this.subcategoryImage,
    required this.categoryName,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'] ?? 0,
      category: json['category'] ?? 0,
      subcategoryName: json['subcategory_name'] ?? "",
      subcategoryImage: json['subcategory_image'] ?? "",
      categoryName: json['category_name'] ?? "",
    );
  }
}