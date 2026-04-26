class ChatRoomListModel {
  final int roomId;
  final ServiceModel service;

  final int buyerId;
  final String buyerName;
  final String buyerImage;

  final int sellerId;
  final String sellerName;
  final String sellerImage;

  final String lastMessage;
  final String updatedAt;

  ChatRoomListModel({
    required this.roomId,
    required this.service,

    required this.buyerId,
    required this.buyerName,
    required this.buyerImage,

    required this.sellerId,
    required this.sellerName,
    required this.sellerImage,

    required this.lastMessage,
    required this.updatedAt,
  });

  factory ChatRoomListModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ChatRoomListModel(
      roomId: json["room_id"] ?? 0,

      service: ServiceModel.fromJson(
        json["service"] ?? {},
      ),

      buyerId: json["buyer_id"] ?? 0,
      buyerName: json["buyer_name"] ?? "",
      buyerImage: json["buyer_image"] ?? "",

      sellerId: json["seller_id"] ?? 0,
      sellerName: json["seller_name"] ?? "",
      sellerImage: json["seller_image"] ?? "",

      lastMessage: json["last_message"] ?? "",
      updatedAt: json["updated_at"] ?? "",
    );
  }
}

class ServiceModel {
  final int id;
  final String serviceName;
  final String serviceImage;
  final String serviceAmount;
  final bool serviceStatus;
  final String serviceDescription;

  final UserProfileModel userProfile;
  final CategoryModel category;
  final SubCategoryModel subcategory;

  ServiceModel({
    required this.id,
    required this.serviceName,
    required this.serviceImage,
    required this.serviceAmount,
    required this.serviceStatus,
    required this.serviceDescription,
    required this.userProfile,
    required this.category,
    required this.subcategory,
  });

  factory ServiceModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ServiceModel(
      id: json["id"] ?? 0,
      serviceName: json["service_name"] ?? "",
      serviceImage: json["service_image"] ?? "",
      serviceAmount:
      (json["service_amount"] ?? "0").toString(),
      serviceStatus: json["service_status"] ?? false,
      serviceDescription:
      json["service_description"] ?? "",

      userProfile: UserProfileModel.fromJson(
        json["user_profile"] ?? {},
      ),

      category: CategoryModel.fromJson(
        json["category"] ?? {},
      ),

      subcategory: SubCategoryModel.fromJson(
        json["subcategory"] ?? {},
      ),
    );
  }
}

class UserProfileModel {
  final int id;
  final String userName;
  final String userPhone;
  final String userEmail;
  final String userImage;

  UserProfileModel({
    required this.id,
    required this.userName,
    required this.userPhone,
    required this.userEmail,
    required this.userImage,
  });

  factory UserProfileModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return UserProfileModel(
      id: json["id"] ?? 0,
      userName: json["user_name"] ?? "",
      userPhone: json["user_phone"] ?? "",
      userEmail: json["user_email"] ?? "",
      userImage: json["user_image"] ?? "",
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

  factory CategoryModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return CategoryModel(
      id: json["id"] ?? 0,
      categoryName: json["category_name"] ?? "",
      categoryImage: json["category_image"] ?? "",
    );
  }
}

class SubCategoryModel {
  final int id;
  final int category;
  final String subcategoryName;
  final String subcategoryImage;

  SubCategoryModel({
    required this.id,
    required this.category,
    required this.subcategoryName,
    required this.subcategoryImage,
  });

  factory SubCategoryModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return SubCategoryModel(
      id: json["id"] ?? 0,
      category: json["category"] ?? 0,
      subcategoryName:
      json["subcategory_name"] ?? "",
      subcategoryImage:
      json["subcategory_image"] ?? "",
    );
  }
}