import 'package:get/get.dart';
import '../../../core/widget/flutter_toast.dart';
import '../../auth/helper/auth_preferences.dart';
import '../model/wishlist_toggle_model.dart';
import '../repository/wishlist_toggle_epository.dart';

// class WishlistToggleController extends GetxController {
//
//   final WishlistToggleRepository _repository = WishlistToggleRepository();
//
//   var isLoading = false.obs;
//   var favoriteIds = <int>{}.obs;
//
//   Future<void> toggleWishlist({
//     required int serviceId,
//   }) async {
//
//     try {
//       isLoading.value = true;
//
//       /// ✅ get userId from SharedPreferences
//       final userId = await AuthPreferences.getUserId();
//
//       if (userId == null) {
//         FlutterToast.error("User not logged in");
//         return;
//       }
//
//       final request = WishlistToggleModel(
//         user: userId,
//         service: serviceId,
//       );
//
//       final response = await _repository.toggleWishlist(request);
//
//       if (response.success) {
//
//         final isAdded =
//         response.message.toLowerCase().contains("added");
//
//         if (isAdded) {
//           favoriteIds.add(serviceId);
//         } else {
//           favoriteIds.remove(serviceId);
//         }
//
//         // FlutterToast.success("Success");
//       }
//
//     } catch (e) {
//       FlutterToast.success("Error ${e.toString()}");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   bool isFavorite(int serviceId) {
//     return favoriteIds.contains(serviceId);
//   }
//
// }

class WishlistToggleController extends GetxController {
  final WishlistToggleRepository _repository =
  WishlistToggleRepository();

  var isLoading = false.obs;

  Future<void> toggleWishlist({
    required int serviceId,
  }) async {
    try {
      isLoading.value = true;

      final userId = await AuthPreferences.getUserId();
      if (userId == null) {
        FlutterToast.error("User not logged in");
        return;
      }

      final response = await _repository.toggleWishlist(
        WishlistToggleModel(
          user: userId,
          service: serviceId,
        ),
      );

      if (response.success) {
        FlutterToast.success(response.message);

        /// ❗ optional: return updated state from API if available
      }
    } finally {
      isLoading.value = false;
    }
  }


}