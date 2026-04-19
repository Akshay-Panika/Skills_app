class BookingModel {
  final bool success;
  final BookingData data;
  final BookingCounts counts;

  BookingModel({
    required this.success,
    required this.data,
    required this.counts,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      success: json["success"] ?? false,
      data: BookingData.fromJson(json["data"] ?? {}),
      counts: BookingCounts.fromJson(json["counts"] ?? {}),
    );
  }
}

class BookingData {
  final List<BookingItem> buyerBookings;
  final List<BookingItem> sellerBookings;

  BookingData({
    required this.buyerBookings,
    required this.sellerBookings,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      buyerBookings: (json["buyer_bookings"] as List? ?? [])
          .map((e) => BookingItem.fromJson(e))
          .toList(),
      sellerBookings: (json["seller_bookings"] as List? ?? [])
          .map((e) => BookingItem.fromJson(e))
          .toList(),
    );
  }
}

class BookingCounts {
  final int buyerTotal;
  final int sellerTotal;
  final int total;

  BookingCounts({
    required this.buyerTotal,
    required this.sellerTotal,
    required this.total,
  });

  factory BookingCounts.fromJson(Map<String, dynamic> json) {
    return BookingCounts(
      buyerTotal: json["buyer_total"] ?? 0,
      sellerTotal: json["seller_total"] ?? 0,
      total: json["total"] ?? 0,
    );
  }
}

class BookingItem {
  final int id;
  final String message;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int buyer;
  final int seller;

  final ServiceModel service;

  BookingItem({
    required this.id,
    required this.message,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.buyer,
    required this.seller,
    required this.service,
  });

  factory BookingItem.fromJson(Map<String, dynamic> json) {
    return BookingItem(
      id: json["id"] ?? 0,
      message: json["message"] ?? "",
      status: json["status"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      buyer: json["buyer"] ?? 0,
      seller: json["seller"] ?? 0,
      service: ServiceModel.fromJson(json["service"] ?? {}),
    );
  }
}

class ServiceModel {
  final int id;
  final String serviceName;
  final String serviceImage;
  final String serviceDescription;

  final double? latitude;
  final double? longitude;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  final UserProfileModel? userProfile;
  final CategoryModel? category;
  final SubcategoryModel? subcategory;

  final String? serviceAmount;
  final bool swipeStatus;
  final bool isFavorite;
  final bool serviceStatus;

  ServiceModel({
    required this.id,
    required this.serviceName,
    required this.serviceImage,
    required this.serviceDescription,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
    this.userProfile,
    this.category,
    this.subcategory,
    this.serviceAmount,
    required this.swipeStatus,
    required this.isFavorite,
    required this.serviceStatus,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json["id"] ?? 0,
      serviceName: json["service_name"] ?? "",
      serviceImage: json["service_image"] ?? "",
      serviceDescription: json["service_description"] ?? "",

      latitude: (json["latitude"] as num?)?.toDouble(),
      longitude: (json["longitude"] as num?)?.toDouble(),

      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),

      userProfile: json["user_profile"] != null
          ? UserProfileModel.fromJson(json["user_profile"])
          : null,

      category: json["category"] != null
          ? CategoryModel.fromJson(json["category"])
          : null,

      subcategory: json["subcategory"] != null
          ? SubcategoryModel.fromJson(json["subcategory"])
          : null,

      serviceAmount: json["service_amount"]?.toString(),

      swipeStatus: json["swipe_status"] ?? false,
      isFavorite: json["is_favorite"] ?? false,
      serviceStatus: json["service_status"] ?? false,
    );
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
      id: json["id"] ?? 0,
      categoryName: json["category_name"] ?? "",
      categoryImage: json["category_image"] ?? "",
    );
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
      id: json["id"] ?? 0,
      category: json["category"] ?? 0,
      subcategoryName: json["subcategory_name"] ?? "",
      subcategoryImage: json["subcategory_image"] ?? "",
      categoryName: json["category_name"] ?? "",
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
      id: json["id"] ?? 0,
      userPhone: json["user_phone"] ?? "",
      userName: json["user_name"] ?? "",
      userEmail: json["user_email"] ?? "",
      userGender: json["user_gender"] ?? "",
      userBio: json["user_bio"] ?? "",
      userImage: json["user_image"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      user: json["user"] ?? 0,
    );
  }
}