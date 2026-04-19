// service_search_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/service_search_model.dart';
import '../repository/service_search_repository.dart';

class ServiceSearchController extends GetxController {
  final ServiceSearchRepository repository =
  ServiceSearchRepository();

  RxBool isLoading = false.obs;

  RxString searchText = ''.obs;

  RxList<ServiceItem> serviceList =
      <ServiceItem>[].obs;

  TextEditingController searchController =
  TextEditingController();

  Future<void> searchServices() async {
    final query = searchText.value.trim();

    if (query.isEmpty) {
      serviceList.clear();
      return;
    }

    isLoading.value = true;

    try {
      final result = await repository.getSearchedServices(
        query: query,
      );

      serviceList.assignAll(result.services);
    } catch (e) {
      serviceList.clear();
    }

    isLoading.value = false;
  }
  void toggleLocalFavorite(int id) {
    final index =
    serviceList.indexWhere((e) => e.id == id);

    if (index != -1) {
      final item = serviceList[index];

      serviceList[index] = item.copyWith(
        isFavorite: !item.isFavorite,
      );

      serviceList.refresh();
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}