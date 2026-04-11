import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../service/controller/service_list_controller.dart';
import '../repository/wishlist_remove_repository.dart';

class WishlistRemoveController extends GetxController {

  final WishlistRemoveRepository repository = WishlistRemoveRepository();

  var isLoading = false.obs;
  var message = "".obs;
  var isSuccess = false.obs;

  Future<void> removeFromFavorite({
    required int userId,
    required int serviceId,
  }) async {
    try {
      isLoading.value = true;

      final res = await repository.removeFavorite(
        userId: userId,
        serviceId: serviceId,
      );

      isSuccess.value = res["success"] ?? false;
      message.value = res["message"] ?? "";

      Get.find<ServiceListController>().fetchServiceList();


    } catch (e) {
      debugPrint("Error ${e.toString()}",);
    } finally {
      isLoading.value = false;
    }
  }
}