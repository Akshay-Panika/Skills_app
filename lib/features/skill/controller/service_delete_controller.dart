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

  Future<void> deleteService({required int serviceId}) async {
    final userId = AuthPreferences.getUserId();

    if (userId == null) {
      message.value = "User not logged in";
      FlutterToast.error("User not logged in");
      return;
    }

    try {
      isLoading.value = true;

      final responseMessage = await repository.deleteService(
        userId: userId,
        serviceId: serviceId,
      );

      message.value = responseMessage;

      FlutterToast.success("Your skill has been deleted");
      Get.find<ServiceListController>().fetchServiceList();
      Get.find<ServiceListByUserController>().fetchMyServices();
    } catch (e) {
      message.value = "Delete failed";
      FlutterToast.error("Error ${message.value}");

    } finally {
      isLoading.value = false;
    }
  }
}