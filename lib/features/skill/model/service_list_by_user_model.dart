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
  final int user;
  final int category;
  final int subcategory;

  Service({
    required this.id,
    required this.serviceImage,
    required this.serviceAmount,
    required this.serviceName,
    required this.serviceStatus,
    required this.serviceDescription,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.category,
    required this.subcategory,
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
      user: json['user'] ?? 0,
      category: json['category'] ?? 0,
      subcategory: json['subcategory'] ?? 0,
    );
  }
}