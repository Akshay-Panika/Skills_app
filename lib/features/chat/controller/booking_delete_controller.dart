import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../auth/helper/auth_preferences.dart';
import '../repository/booking_delete_repository.dart';

class BookingDeleteController extends GetxController {

  final BookingDeleteRepository repository = BookingDeleteRepository();


  final isLoading = false.obs;

  Future<void> deleteBooking(int bookingId) async {
    try {
      isLoading.value = true;

      final userId = await AuthPreferences.getUserId();

      if (userId == null) {
        debugPrint("Error: User not logged in");
        return;
      }

      final response = await repository.deleteBooking(
        bookingId: bookingId,
        userId: userId,
      );

      if (response.success) {
        debugPrint("Success: ${response.message}");

        /// optional: go back or refresh list
        Get.back(result: true);

      } else {
        debugPrint("Error ${response.message}");
      }

    } catch (e) {
      debugPrint("Error ${e.toString()}", );
    } finally {
      isLoading.value = false;
    }
  }
}