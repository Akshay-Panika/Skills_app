class BookingDeleteResponse {
  final bool success;
  final String message;

  BookingDeleteResponse({
    required this.success,
    required this.message,
  });

  factory BookingDeleteResponse.fromJson(Map<String, dynamic> json) {
    return BookingDeleteResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}