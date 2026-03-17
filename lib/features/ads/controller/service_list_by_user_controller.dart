import 'dart:developer';
import 'package:get/get.dart';
import '../../auth/helper/auth_preferences.dart';
import '../model/service_list_by_user_model.dart';
import '../repository/service_list_byuser_repository.dart';

class ServiceListByUserController extends GetxController {
  final ServiceListByUserRepository repository;

  ServiceListByUserController({required this.repository});

  var isLoading = false.obs;
  var serviceList = <Service>[].obs;
  var count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyServices(); // 🔥 auto call
  }

  Future<void> fetchMyServices() async {
    try {
      isLoading.value = true;

      final userId = await AuthPreferences.getUserId();

      if (userId == null) {
        log("User not logged in");
        return;
      }

      final data = await repository.getServicesByUser(userId);

      serviceList.value = data.services;
      count.value = data.count;

    } catch (e) {
      log("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}