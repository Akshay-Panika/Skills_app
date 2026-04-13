class UserProfileModel {
  final int? id;
  final String userPhone;
  final String userName;
  final String userEmail;
  final String userGender;
  final String userBio;
  final int user;

  final String? userImage;
  final String? createdAt;

  UserProfileModel({
    this.id,
    required this.userPhone,
    required this.userName,
    required this.userEmail,
    required this.userGender,
    required this.userBio,
    required this.user,
    this.userImage,
    this.createdAt,
  });

  // JSON → Model
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'],
      userPhone: json['user_phone'] ?? '',
      userName: json['user_name'] ?? '',
      userEmail: json['user_email'] ?? '',
      userGender: json['user_gender'] ?? '',
      userBio: json['user_bio'] ?? '',
      user: json['user'],
      userImage: json['user_image'],
      createdAt: json['created_at'],
    );
  }

  // Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_phone': userPhone,
      'user_name': userName,
      'user_email': userEmail,
      'user_gender': userGender,
      'user_bio': userBio,
      'user': user,
      'user_image': userImage,
      'created_at': createdAt,
    };
  }
}