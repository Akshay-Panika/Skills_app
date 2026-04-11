import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:skills_app/features/service/controller/booking_check_controller.dart';
import '../../auth/helper/auth_preferences.dart';
import '../../chat/controller/booking_controller.dart';
import '../model/booking_create_model.dart';
import '../repository/booking_create_repository.dart';

class BookingCreateController extends GetxController {
  final BookingCreateRepository repository;

  BookingCreateController(this.repository);

  var isLoading = false.obs;
  var bookingResponse = Rxn<BookingCreateModel>();

  Future<void> createBooking({
    required int serviceId,
    required String message,
  }) async {
    try {
      isLoading.value = true;

      final userId = await AuthPreferences.getUserId();

      if (userId == null) {
        throw Exception("User not logged in");
      }

      final result = await repository.createBooking(
        buyer: userId,
        service: serviceId,
        message: message,
      );

      bookingResponse.value = result;
      Get.find<BookingCheckController>().checkServiceBooking(serviceId);
      Get.find<BookingController>().fetchBookings();
      debugPrint("Success : ${result.message}");

    } catch (e) {
      debugPrint("Error : ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }
}