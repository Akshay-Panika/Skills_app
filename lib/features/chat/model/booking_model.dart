class BookingModel {
  final bool success;
  final BookingData data;
  final BookingCounts counts;

  BookingModel({
    required this.success,
    required this.data,
    required this.counts,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      success: json["success"] ?? false,
      data: BookingData.fromJson(json["data"] ?? {}),
      counts: BookingCounts.fromJson(json["counts"] ?? {}),
    );
  }
}

class BookingData {
  final List<BookingItem> buyerBookings;
  final List<BookingItem> sellerBookings;

  BookingData({
    required this.buyerBookings,
    required this.sellerBookings,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      buyerBookings: (json["buyer_bookings"] as List? ?? [])
          .map((e) => BookingItem.fromJson(e))
          .toList(),
      sellerBookings: (json["seller_bookings"] as List? ?? [])
          .map((e) => BookingItem.fromJson(e))
          .toList(),
    );
  }
}

class BookingCounts {
  final int buyerTotal;
  final int sellerTotal;
  final int total;

  BookingCounts({
    required this.buyerTotal,
    required this.sellerTotal,
    required this.total,
  });

  factory BookingCounts.fromJson(Map<String, dynamic> json) {
    return BookingCounts(
      buyerTotal: json["buyer_total"] ?? 0,
      sellerTotal: json["seller_total"] ?? 0,
      total: json["total"] ?? 0,
    );
  }
}

class BookingItem {
  final int id;
  final String message;
  final String status;
  final String createdAt;
  final String updatedAt;
  final int buyer;
  final int seller;

  final ServiceModel service;

  BookingItem({
    required this.id,
    required this.message,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.buyer,
    required this.seller,
    required this.service,
  });

  factory BookingItem.fromJson(Map<String, dynamic> json) {
    return BookingItem(
      id: json["id"] ?? 0,
      message: json["message"] ?? "",
      status: json["status"] ?? "",
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
      buyer: json["buyer"] ?? 0,
      seller: json["seller"] ?? 0,
      service: ServiceModel.fromJson(json["service"] ?? {}),
    );
  }
}

class ServiceModel {
  final int id;
  final String serviceName;
  final String serviceImage;
  final String serviceDescription;

  final double latitude;
  final double longitude;

  final String createdAt;
  final String updatedAt;

  final int user;
  final int category;
  final int subcategory;

  final dynamic serviceAmount;
  final bool swipeStatus;
  final bool isFavorite;
  final bool serviceStatus;

  ServiceModel({
    required this.id,
    required this.serviceName,
    required this.serviceImage,
    required this.serviceDescription,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.category,
    required this.subcategory,
    required this.serviceAmount,
    required this.swipeStatus,
    required this.isFavorite,
    required this.serviceStatus,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json["id"] ?? 0,
      serviceName: json["service_name"] ?? "",
      serviceImage: json["service_image"] ?? "",
      serviceDescription: json["service_description"] ?? "",

      latitude: (json["latitude"] ?? 0).toDouble(),
      longitude: (json["longitude"] ?? 0).toDouble(),

      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",

      user: json["user"] ?? 0,
      category: json["category"] ?? 0,
      subcategory: json["subcategory"] ?? 0,

      serviceAmount: json["service_amount"],
      swipeStatus: json["swipe_status"] ?? false,
      isFavorite: json["is_favorite"] ?? false,
      serviceStatus: json["service_status"] ?? false,
    );
  }
}