class AddServiceByUserModel {
  final int id;
  final String serviceName;
  final String serviceImage;
  final String? serviceAmount;
  final bool serviceStatus;
  final bool swipeStatus;
  final String serviceDescription;
  final int user;
  final int category;
  final int subcategory;
  final double? latitude;
  final double? longitude;
  final String? createdAt;
  final String? updatedAt;

  AddServiceByUserModel({
    required this.id,
    required this.serviceName,
    required this.serviceImage,
    required this.serviceAmount,
    required this.serviceStatus,
    required this.swipeStatus,
    required this.serviceDescription,
    required this.user,
    required this.category,
    required this.subcategory,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
  });

  factory AddServiceByUserModel.fromJson(Map<String, dynamic> json) {
    return AddServiceByUserModel(
      id: json['id'],
      serviceName: json['service_name'] ?? "",
      serviceImage: json['service_image'] ?? "",
      serviceAmount: json['service_amount']?.toString(),
      serviceStatus: json['service_status'] ?? false,
      swipeStatus: json['swipe_status'] ?? false,
      serviceDescription: json['service_description'] ?? "",
      user: json['user'],
      category: json['category'],
      subcategory: json['subcategory'],
      latitude: (json['latitude'] != null)
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: (json['longitude'] != null)
          ? double.tryParse(json['longitude'].toString())
          : null,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}