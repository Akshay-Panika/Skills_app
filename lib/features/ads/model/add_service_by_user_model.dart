class AddServiceByUserModel {
  final int id;
  final String serviceName;
  final String serviceImage;
  final String? serviceAmount;
  final bool serviceStatus;
  final String serviceDescription;
  final int user;
  final int category;
  final int subcategory;

  AddServiceByUserModel({
    required this.id,
    required this.serviceName,
    required this.serviceImage,
    required this.serviceAmount,
    required this.serviceStatus,
    required this.serviceDescription,
    required this.user,
    required this.category,
    required this.subcategory,
  });

  factory AddServiceByUserModel.fromJson(Map<String, dynamic> json) {
    return AddServiceByUserModel(
      id: json['id'],
      serviceName: json['service_name'] ?? "",
      serviceImage: json['service_image'] ?? "",
      serviceAmount: json['service_amount']?.toString(),
      serviceStatus: json['service_status'] ?? false,
      serviceDescription: json['service_description'] ?? "",
      user: json['user'],
      category: json['category'],
      subcategory: json['subcategory'],
    );
  }
}