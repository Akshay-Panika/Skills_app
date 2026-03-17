import 'package:get/get.dart';
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
      );

      Get.snackbar("Success", "Service Created Successfully");
      Get.find<ServiceListController>().fetchServiceList();
      print("Created Service ID: ${data.id}");

    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}