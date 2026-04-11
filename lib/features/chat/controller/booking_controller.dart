import 'package:get/get.dart';
import '../../auth/helper/auth_preferences.dart';
import '../model/booking_model.dart';
import '../repository/booinkg_repository.dart';

class BookingController extends GetxController {
  final BookingRepository repository = BookingRepository();

  var isLoading = false.obs;

  var allChats = <BookingItem>[].obs;
  var buyerBookings = <BookingItem>[].obs;
  var sellerBookings = <BookingItem>[].obs;

  var counts = BookingCounts(
    buyerTotal: 0,
    sellerTotal: 0,
    total: 0,
  ).obs;

  @override
  void onInit() {
    fetchBookings();
    super.onInit();
  }

  Future<void> fetchBookings() async {
    try {
      isLoading(true);

      final userId = await AuthPreferences.getUserId();
      if (userId == null) return;

      final result = await repository.getUserBookings(userId);

      // ✅ Assign buyer & seller
      buyerBookings.value = result.data.buyerBookings;
      sellerBookings.value = result.data.sellerBookings;

      // ✅ FIX: merge both into allChats
      allChats.value = [
        ...result.data.buyerBookings,
        ...result.data.sellerBookings,
      ];

      counts.value = result.counts;

    } catch (e) {
      print("Booking Error: $e");
    } finally {
      isLoading(false);
    }
  }

  // 🔥 Optional: Pull to refresh support
  Future<void> refreshBookings() async {
    await fetchBookings();
  }
}