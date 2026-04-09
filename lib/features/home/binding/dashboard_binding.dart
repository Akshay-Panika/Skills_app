import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../../category/controller/category_controller.dart';
import '../../location/controller/location_controller.dart';
import '../../service/controller/service_list_controller.dart';
import '../../service/repository/service_list_repository.dart';
import '../../skill/controller/service_delete_controller.dart';
import '../../skill/controller/service_list_by_user_controller.dart';
import '../../skill/repository/service_list_byuser_repository.dart';
import '../controller/home_screen_controller.dart';
import '../screen/home_screen.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LocationController(), permanent: true);
    Get.put(ScrollStatusController(), permanent: true);

    Get.put(CategoryController(), permanent: true);
    Get.put(ServiceListController(ServiceListRepository()), permanent: true);
    Get.put(HomeScreenController(), permanent: true);

    Get.lazyPut(() => ServiceListByUserController(
      repository: ServiceListByUserRepository(),
    ));

    Get.lazyPut(() => ServiceDeleteController());
  }
}