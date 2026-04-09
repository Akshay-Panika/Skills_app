import 'package:get/get.dart';

import '../controller/service_list_by_user_controller.dart';
import '../controller/service_delete_controller.dart';
import '../repository/service_list_byuser_repository.dart';

class ServiceListByUserBinding extends Bindings {
  @override
  void dependencies() {

    /// ✅ Controller
    Get.lazyPut<ServiceListByUserController>(
          () => ServiceListByUserController(
        repository: Get.find<ServiceListByUserRepository>(),
      ),
    );

    /// ✅ Delete Controller
    Get.lazyPut<ServiceDeleteController>(
          () => ServiceDeleteController(),
    );
  }
}