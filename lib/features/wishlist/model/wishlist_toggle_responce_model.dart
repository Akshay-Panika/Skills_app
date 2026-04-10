class WishlistToggleResponseModel {
  final bool success;
  final String message;

  WishlistToggleResponseModel({
    required this.success,
    required this.message,
  });

  factory WishlistToggleResponseModel.fromJson(Map<String, dynamic> json) {
    return WishlistToggleResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? "",
    );
  }
}