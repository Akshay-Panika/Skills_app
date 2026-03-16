class ServiceListModel {
  final int id;
  final String serviceImage;
  final String? serviceAmount;
  final String serviceName;
  final bool serviceStatus;
  final String serviceDescription;
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
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
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