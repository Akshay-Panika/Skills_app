import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../model/service_list_model.dart';
import '../repository/service_list_repository.dart';

class ServiceListController extends GetxController {
  var isLoading = true.obs;
  var services = <ServiceListModel>[].obs;
  var count = 0.obs;

  final ServiceListRepository repository;

  ServiceListController([ServiceListRepository? repo])
      : repository = repo ?? ServiceListRepository();

  @override
  void onInit() {
    fetchServiceList();
    super.onInit();
  }

  Future<void> fetchServiceList() async {
    try {
      isLoading.value = true;
      final response = await repository.getServiceList();
      services.assignAll(response.services);

      services.value = response.services;
      count.value = response.count;
    } catch (e) {
      debugPrint('Service Error ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleLocalFavorite(int id) {
    final index = services.indexWhere((e) => e.id == id);

    if (index != -1) {
      services[index].isFavorite = !services[index].isFavorite;

      /// 🔥 THIS is required for UI update
      services.refresh();
    }
  }
}