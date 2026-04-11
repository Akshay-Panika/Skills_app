import 'package:get/get.dart';
import '../../auth/helper/auth_preferences.dart';
import '../model/booking_check_model.dart';
import '../repository/booking_check_repository.dart';

class BookingCheckController extends GetxController {
  final BookingCheckRepository repository = BookingCheckRepository();

  var isLoading = false.obs;

  var alreadyBooked = false.obs;
  var bookingId = 0.obs;
  var status = "".obs;
  var message = "".obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> checkServiceBooking(int serviceId) async {
    try {
      isLoading(true);

      final userId = await AuthPreferences.getUserId();
      if (userId == null) return;

      final result = await repository.checkBooking(
        buyerId: userId,
        serviceId: serviceId,
      );

      alreadyBooked.value = result.alreadyBooked;
      bookingId.value = result.bookingId;
      status.value = result.status;
      message.value = result.message;

    } catch (e) {
      print("Booking Check Error: $e");
    } finally {
      isLoading(false);
    }
  }
}