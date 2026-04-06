class ServiceListModel {
  final int id;
  final String serviceImage;
  final String? serviceAmount;
  final String serviceName;
  final bool serviceStatus;
  final bool swipeStatus;
  final String serviceDescription;
  final double? latitude;
  final double? longitude;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int user;
  final int category;
  final int subcategory;

  ServiceListModel({
    required this.id,
    required this.serviceImage,
    this.serviceAmount,
    required this.serviceName,
    required this.serviceStatus,
    required this.swipeStatus,
    required this.serviceDescription,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
    required this.user,
    required this.category,
    required this.subcategory,
  });

  factory ServiceListModel.fromJson(Map<String, dynamic> json) {
    return ServiceListModel(
      id: json['id'],
      serviceImage: json['service_image'] ?? "",
      serviceAmount: json['service_amount']?.toString(), // ✅ safe convert
      serviceName: json['service_name'] ?? "",
      serviceStatus: json['service_status'] ?? false,
      swipeStatus: json['swipe_status'] ?? false,
      serviceDescription: json['service_description'] ?? "",
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      user: json['user'] ?? 0,
      category: json['category'] ?? 0,
      subcategory: json['subcategory'] ?? 0,
    );
  }
}
class ServiceListResponse {
  final int count;
  final List<ServiceListModel> services;

  ServiceListResponse({
    required this.count,
    required this.services,
  });

  factory ServiceListResponse.fromJson(Map<String, dynamic> json) {
    return ServiceListResponse(
      count: json['count'] ?? 0,
      services: (json['services'] as List? ?? [])
          .map((e) => ServiceListModel.fromJson(e))
          .toList(),
    );
  }
}