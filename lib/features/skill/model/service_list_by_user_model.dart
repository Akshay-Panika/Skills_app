class ServiceListByUserModel {
  final int count;
  final List<Service> services;

  ServiceListByUserModel({
    required this.count,
    required this.services,
  });

  factory ServiceListByUserModel.fromJson(Map<String, dynamic> json) {
    return ServiceListByUserModel(
      count: json['count'] ?? 0,
      services: (json['services'] as List? ?? [])
          .map((e) => Service.fromJson(e))
          .toList(),
    );
  }
}

class Service {
  final int id;
  final String serviceImage;
  final String? serviceAmount;
  final String serviceName;
  final bool serviceStatus;
  final String serviceDescription;
  final String createdAt;
  final String updatedAt;
  final int category;
  final int subcategory;
  final UserProfileModel? userProfile;


  Service({
    required this.id,
    required this.serviceImage,
    required this.serviceAmount,
    required this.serviceName,
    required this.serviceStatus,
    required this.serviceDescription,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
    required this.subcategory,
    this.userProfile,

  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] ?? 0,
      serviceImage: json['service_image'] ?? "",
      serviceAmount: json['service_amount'] != null
          ? json['service_amount'].toString()
          : null,
      serviceName: json['service_name'] ?? "",
      serviceStatus: json['service_status'] ?? false,
      serviceDescription: json['service_description'] ?? "",
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