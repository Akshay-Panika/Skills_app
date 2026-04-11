import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../model/booking_model.dart';

class BookingRepository {

  Future<BookingModel> getUserBookings(int userId) async {
    try {
      final response = await ApiClient.dio.get(
        "booking/user/$userId/",
      );

      return BookingModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}