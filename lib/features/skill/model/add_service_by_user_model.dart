class AddServiceByUserModel {
  final int id;
  final String serviceName;
  final String serviceImage;
  final String? serviceAmount;
  final bool serviceStatus;
  final bool swipeStatus;
  final String serviceDescription;
  final int user;
  final int categoryId;
  final int subcategoryId;
  final double? latitude;
  final double? longitude;
  final String? createdAt;
  final String? updatedAt;

  AddServiceByUserModel({
    required this.id,
    required this.serviceName,
    required this.serviceImage,
    this.serviceAmount,
    required this.serviceStatus,
    required this.swipeStatus,
    required this.serviceDescription,
    required this.user,
    required this.categoryId,
    required this.subcategoryId,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
  });

  factory AddServiceByUserModel.fromJson(Map<String, dynamic> json) {
    return AddServiceByUserModel(
      id: json['id'] ?? 0, // ✅ FIX
      serviceName: json['service_name'] ?? "",
      serviceImage: json['service_image'] ?? "",
      serviceAmount: json['service_amount']?.toString(),
      serviceStatus: json['service_status'] ?? false,
      swipeStatus: json['swipe_status'] ?? false,
      serviceDescription: json['service_description'] ?? "",
      user: json['user'] ?? 0, // ✅ FIX
      categoryId: json['category_id'] ?? 0, // ✅ FIX
      subcategoryId: json['subcategory_id'] ?? 0, // ✅ FIX
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}