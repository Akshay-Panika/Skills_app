import 'package:get/get.dart';
import '../../auth/helper/auth_preferences.dart';
import '../model/service_list_by_user_model.dart';
import '../repository/service_list_byuser_repository.dart';

class ServiceListByUserController extends GetxController {
  final ServiceListByUserRepository repository = ServiceListByUserRepository();


  var isLoading = false.obs;
  var serviceList = <ServiceModel>[].obs;
  var count = 0.obs;
  var errorMessage = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyServices();
  }

  /// 🔹 Fetch user services
  Future<void> fetchMyServices() async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      final userId = await AuthPreferences.getUserId();

      if (userId == null) {
        errorMessage.value = "User not logged in";
        return;
      }

      final data = await repository.getServicesByUser(userId);

      serviceList.value = data.services;
      count.value = data.count;

    } catch (e) {
      errorMessage.value = "Failed to load services";
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔥 DELETE ke baad UI se remove
  void removeService(int serviceId) {
    serviceList.removeWhere((s) => s.id == serviceId);

    // optional: count update
    count.value = serviceList.length;
  }

  /// 🔁 OPTIONAL: refresh from API (agar fresh data chahiye)
  Future<void> refreshServices() async {
    await fetchMyServices();
  }
}