class ServiceListModel {
  final int id;
  final String serviceImage;
  final String? serviceAmount;
  final String serviceName;
  final bool serviceStatus;
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
      serviceImage: json['service_image'],
      serviceAmount: json['service_amount'],
      serviceName: json['service_name'],
      serviceStatus: json['service_status'],
      serviceDescription: json['service_description'],
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      user: json['user'],
      category: json['category'],
      subcategory: json['subcategory'],
    );
  }
}

class ServiceListResponse {
  final int count;
  final List<ServiceListModel> services;

  ServiceListResponse({required this.count, required this.services});

  factory ServiceListResponse.fromJson(Map<String, dynamic> json) {
    return ServiceListResponse(
      count: json['count'],
      services: (json['services'] as List)
          .map((e) => ServiceListModel.fromJson(e))
          .toList(),
    );
  }
}