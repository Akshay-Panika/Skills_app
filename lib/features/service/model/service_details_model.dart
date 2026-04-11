class ServiceDetailsModel {
  final int id;
  final String serviceImage;
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
    required this.serviceImage,
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
      id: json['id'] as int,
      serviceImage: json['service_image'] as String,
      serviceAmount: json['service_amount']?.toString(),
      swipeStatus: json['swipe_status'] as bool,
      serviceName: json['service_name'] as String,
      serviceStatus: json['service_status'] as bool,
      serviceDescription: json['service_description'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      user: json['user'] as int,
      category: json['category'] as int,
      subcategory: json['subcategory'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service_image': serviceImage,
      'service_amount': serviceAmount,
      'swipe_status': swipeStatus,
      'service_name': serviceName,
      'service_status': serviceStatus,
      'service_description': serviceDescription,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user': user,
      'category': category,
      'subcategory': subcategory,
    };
  }
}