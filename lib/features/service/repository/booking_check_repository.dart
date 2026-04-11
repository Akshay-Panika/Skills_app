import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../model/booking_check_model.dart';

class BookingCheckRepository {

  Future<BookingCheckModel> checkBooking({
    required int buyerId,
    required int serviceId,
  }) async {
    try {
      final response = await ApiClient.dio.get(
        "booking/check/",
        queryParameters: {
          "buyer_id": buyerId,
          "service_id": serviceId,
        },
      );

      return BookingCheckModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}