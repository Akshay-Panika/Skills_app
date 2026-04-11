class BookingCreateModel {
  final bool success;
  final String message;
  final BookingData data;

  BookingCreateModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory BookingCreateModel.fromJson(Map<String, dynamic> json) {
    return BookingCreateModel(
      success: json['success'],
      message: json['message'],
      data: BookingData.fromJson(json['data']),
    );
  }
}

class BookingData {
  final int id;
  final String message;
  final String status;
  final int buyer;
  final int seller;
  final ServiceModel service;

  BookingData({
    required this.id,
    required this.message,
    required this.status,
    required this.buyer,
    required this.seller,
    required this.service,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      id: json['id'],
      message: json['message'] ?? '',
      status: json['status'] ?? '',
      buyer: json['buyer'],
      seller: json['seller'],
      service: ServiceModel.fromJson(json['service']),
    );
  }
}

class ServiceModel {
  final int id;
  final String serviceName;
  final String serviceImage;

  ServiceModel({
    required this.id,
    required this.serviceName,
    required this.serviceImage,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      serviceName: json['service_name'] ?? '',
      serviceImage: json['service_image'] ?? '',
    );
  }
}