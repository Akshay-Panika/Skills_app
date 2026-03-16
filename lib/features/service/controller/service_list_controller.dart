import 'package:get/get.dart';

import '../model/service_list_model.dart';
import '../repository/service_list_repository.dart';

class ServiceListController extends GetxController {
  var isLoading = true.obs;
  var services = <ServiceListModel>[].obs;
  var count = 0.obs;

  final ServiceListRepository repository;

  ServiceListController({required this.repository});

  @override
  void onInit() {
    fetchServiceList();
    super.onInit();
  }

  void fetchServiceList() async {
    try {
      isLoading.value = true;
      final response = await repository.getServiceList();
      services.value = response.services;
      count.value = response.count;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}