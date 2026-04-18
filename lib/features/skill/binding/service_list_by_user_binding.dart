import 'package:get/get.dart';

import '../controller/service_list_by_user_controller.dart';
import '../controller/service_delete_controller.dart';

class ServiceListByUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=> ServiceListByUserController(), fenix: true);
    Get.lazyPut(()=> ServiceDeleteController(), fenix: true);
  }
}