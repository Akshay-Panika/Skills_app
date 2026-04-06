class ServiceDetailsModel {
  final int id;
  final String? serviceImage;
  final String? serviceAmount;
  final bool swipeStatus;
  final String serviceName;
  final bool serviceStatus;
  final String serviceDescription;
  final double latitude;
  final double longitude;
  final String createdAt;
  final String updatedAt;
  final int user;
  final int category;
  final int subcategory;

  ServiceDetailsModel({
    required this.id,
    this.serviceImage,
    this.serviceAmount,
    required this.swipeStatus,
    required this.serviceName,
    required this.serviceStatus,
    required this.serviceDescription,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.category,
    required this.subcategory,
  });

  factory ServiceDetailsModel.fromJson(Map<String, dynamic> json) {
    return ServiceDetailsModel(
      id: json['id'],
      serviceImage: json['service_image'],
      serviceAmount: json["service_amount"]?.toString(),
      swipeStatus: json['swipe_status'] ?? false,
      serviceName: json['service_name'] ?? '',
      serviceStatus: json['service_status'] ?? false,
      serviceDescription: json['service_description'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      user: json['user'] ?? 0,
      category: json['category'] ?? 0,
      subcategory: json['subcategory'] ?? 0,
    );
  }
}