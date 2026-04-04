import 'package:get/get.dart';
import 'package:skills_app/core/widget/flutter_toast.dart';
import 'package:skills_app/features/ads/controller/service_list_by_user_controller.dart';
import '../../auth/helper/auth_preferences.dart';
import '../../service/controller/service_list_controller.dart';
import '../repository/add_service_by_user_repository.dart';

class AddServiceByUserController extends GetxController {

  final AddServiceByUserRepository repository;

  AddServiceByUserController({required this.repository});

  var isLoading = false.obs;

  Future<void> createService({
    required int categoryId,
    required int subcategoryId,
    required String name,
    required String description,
    required String amount,
    required bool status,
    required String imagePath,
    required double latitude,
    required double longitude,
  }) async {
    try {
      isLoading.value = true;

      final userId = await AuthPreferences.getUserId();

      if (userId == null) {
        Get.snackbar("Error", "User not logged in");
        return;
      }

      final data = await repository.createService(
        userId: userId,
        categoryId: categoryId,
        subcategoryId: subcategoryId,
        name: name,
        description: description,
        amount: amount,
        status: status,
        imagePath: imagePath,
        latitude: latitude,
        longitude: longitude,
      );

      FlutterToast.success("Service Created Successfully");
      Get.find<ServiceListController>().fetchServiceList();
      Get.find<ServiceListByUserController>().fetchMyServices();
      print("Created Service ID: ${data.id}");

    } catch (e) {
      FlutterToast.error("Error ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }
}