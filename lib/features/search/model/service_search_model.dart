// service_search_model.dart

class ServiceSearchModel {
  final int count;
  final List<ServiceItem> services;

  ServiceSearchModel({
    required this.count,
    required this.services,
  });

  factory ServiceSearchModel.fromJson(Map<String, dynamic> json) {
    return ServiceSearchModel(
      count: json["count"] ?? 0,
      services: (json["services"] as List? ?? [])
          .map((e) => ServiceItem.fromJson(e))
          .toList(),
    );
  }
}

class ServiceItem {
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

  final UserProfile userProfile;
  final Category category;
  final SubCategory subcategory;

  ServiceItem({
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
    required this.userProfile,
    required this.category,
    required this.subcategory,
  });

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      id: json["id"],
      distance: json["distance"],
      serviceImage: json["service_image"] ?? "",
      serviceAmount: json["service_amount"],
      swipeStatus: json["swipe_status"] ?? false,
      isFavorite: json["is_favorite"] ?? false,
      serviceName: json["service_name"] ?? "",
      serviceStatus: json["service_status"] ?? false,
      serviceDescription: json["service_description"] ?? "",
      latitude: json["latitude"]?.toDouble(),
      longitude: json["longitude"]?.toDouble(),
      userProfile: UserProfile.fromJson(json["user_profile"]),
      category: Category.fromJson(json["category"]),
      subcategory: SubCategory.fromJson(json["subcategory"]),
    );
  }

  ServiceItem copyWith({
    int? id,
    String? distance,
    String? serviceImage,
    String? serviceAmount,
    bool? swipeStatus,
    bool? isFavorite,
    String? serviceName,
    bool? serviceStatus,
    String? serviceDescription,
    double? latitude,
    double? longitude,
    UserProfile? userProfile,
    Category? category,
    SubCategory? subcategory,
  }) {
    return ServiceItem(
      id: id ?? this.id,
      distance: distance ?? this.distance,
      serviceImage: serviceImage ?? this.serviceImage,
      serviceAmount: serviceAmount ?? this.serviceAmount,
      swipeStatus: swipeStatus ?? this.swipeStatus,
      isFavorite: isFavorite ?? this.isFavorite,
      serviceName: serviceName ?? this.serviceName,
      serviceStatus: serviceStatus ?? this.serviceStatus,
      serviceDescription:
      serviceDescription ?? this.serviceDescription,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      userProfile: userProfile ?? this.userProfile,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
    );
  }
}

class UserProfile {
  final int id;
  final String userImage;
  final String userName;
  final String userPhone;

  UserProfile({
    required this.id,
    required this.userImage,
    required this.userName,
    required this.userPhone,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json["id"],
      userImage: json["user_image"] ?? "",
      userName: json["user_name"] ?? "",
      userPhone: json["user_phone"] ?? "",
    );
  }
}

class Category {
  final int id;
  final String categoryName;

  Category({
    required this.id,
    required this.categoryName,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["id"],
      categoryName: json["category_name"] ?? "",
    );
  }
}

class SubCategory {
  final int id;
  final String subcategoryName;

  SubCategory({
    required this.id,
    required this.subcategoryName,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json["id"],
      subcategoryName: json["subcategory_name"] ?? "",
    );
  }
}