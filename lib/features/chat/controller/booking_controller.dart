import 'package:get/get.dart';
import '../../auth/helper/auth_preferences.dart';
import '../model/booking_model.dart';
import '../repository/booinkg_repository.dart';

class BookingController extends GetxController {
  final BookingRepository repository = BookingRepository();

  var isLoading = false.obs;
  var errorMessage = "".obs;

  var allChats = <BookingItem>[].obs;

  var counts = BookingCounts(
    buyerTotal: 0,
    sellerTotal: 0,
    total: 0,
  ).obs;

  int currentUserId = 0;

  @override
  void onInit() {
    fetchBookings();
    super.onInit();
  }

  Future<void> fetchBookings() async {
    try {
      isLoading(true);
      errorMessage("");

      final userId = await AuthPreferences.getUserId();
      if (userId == null) {
        errorMessage("User not found");
        return;
      }

      currentUserId = userId;

      final result = await repository.getUserBookings(userId);

      allChats.value = [
        ...result.data.buyerBookings,
        ...result.data.sellerBookings,
      ];

      counts.value = result.counts;

    } catch (e) {
      errorMessage("Something went wrong");
      print("Booking Error: $e");
    } finally {
      isLoading(false);
    }
  }

  // ✅ BUYING
  List<BookingItem> get buyingChats =>
      allChats.where((e) => e.buyer == currentUserId).toList();

  // ✅ SELLING
  List<BookingItem> get sellingChats =>
      allChats.where((e) => e.seller == currentUserId).toList();

  // ✅ ALL
  List<BookingItem> get all => allChats;
}