// service_search_binding.dart

import 'package:get/get.dart';

import '../../wishlist/controller/wishlist_toggle_controller.dart';
import '../controller/service_search_controller.dart';
import '../repository/service_search_repository.dart';

class ServiceSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceSearchRepository>(
          () => ServiceSearchRepository(),
    );

    Get.lazyPut<ServiceSearchController>(
          () => ServiceSearchController(),
    );

    Get.lazyPut(() => WishlistToggleController(), fenix: true);
  }
}