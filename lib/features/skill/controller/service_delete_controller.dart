import 'package:get/get.dart';
import 'package:skills_app/core/widget/flutter_toast.dart';
import 'package:skills_app/features/skill/controller/service_list_by_user_controller.dart';
import '../../auth/helper/auth_preferences.dart';
import '../../service/controller/service_list_controller.dart';
import '../repository/service_delete_repository.dart';

class ServiceDeleteController extends GetxController {
  final ServiceDeleteRepository repository = ServiceDeleteRepository();

  var isLoading = false.obs;
  var message = "".obs;

  Future<void> deleteService({
    required List<int> serviceIds,
  }) async {
    final userId = AuthPreferences.getUserId();

    if (userId == null) {
      FlutterToast.error("User not logged in");
      return;
    }

    if (serviceIds.isEmpty) return;

    try {
      isLoading.value = true;

      final responseMessage = await repository.deleteService(
        userId: userId,
        serviceIds: serviceIds,
      );

      message.value = responseMessage;

      FlutterToast.success(responseMessage);

      await Get.find<ServiceListController>().fetchServiceList();
      await Get.find<ServiceListByUserController>().fetchMyServices();

    } finally {
      isLoading.value = false;
    }
  }
}