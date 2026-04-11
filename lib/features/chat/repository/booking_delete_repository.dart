import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../model/booking_delete_response.dart';

class BookingDeleteRepository {

  Future<BookingDeleteResponse> deleteBooking({
    required int bookingId,
    required int userId,
  }) async {
    try {
      final response = await ApiClient.dio.delete(
        "booking/delete/$bookingId/$userId/",
      );

      return BookingDeleteResponse.fromJson(response.data);

    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? "Delete failed",
      );
    }
  }
}