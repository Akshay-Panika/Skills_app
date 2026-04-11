class BookingCheckModel {
  final bool success;
  final bool alreadyBooked;
  final int bookingId;
  final String status;
  final String message;

  BookingCheckModel({
    required this.success,
    required this.alreadyBooked,
    required this.bookingId,
    required this.status,
    required this.message,
  });

  factory BookingCheckModel.fromJson(Map<String, dynamic> json) {
    return BookingCheckModel(
      success: json["success"] ?? false,
      alreadyBooked: json["already_booked"] ?? false,
      bookingId: json["booking_id"] ?? 0,
      status: json["status"] ?? "",
      message: json["message"] ?? "",
    );
  }
}