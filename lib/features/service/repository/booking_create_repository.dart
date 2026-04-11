import '../../../core/network/api_client.dart';
import '../model/booking_create_model.dart';

class BookingCreateRepository {
  Future<BookingCreateModel> createBooking({
    required int buyer,
    required int service,
    required String message,
  }) async {
    try {
      final response = await ApiClient.dio.post(
        "booking/create/",
        data: {
          "buyer": buyer,
          "service": service,
          "message": message,
        },
      );

      return BookingCreateModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}