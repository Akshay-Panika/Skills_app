import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/widget/flutter_toast.dart';
import '../../auth/helper/auth_preferences.dart';
import '../model/wishlist_toggle_model.dart';
import '../repository/wishlist_toggle_epository.dart';

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
        debugPrint("${response.message}");

      }
    } finally {
      isLoading.value = false;
    }
  }


}