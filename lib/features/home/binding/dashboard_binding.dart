import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../../account/controller/user_profile_controller.dart';
import '../../category/controller/category_controller.dart';
import '../../chat/controller/booking_controller.dart';
import '../../chat/controller/booking_delete_controller.dart';
import '../../location/controller/location_controller.dart';
import '../../service/controller/service_list_controller.dart';
import '../../skill/controller/service_delete_controller.dart';
import '../../skill/controller/service_list_by_user_controller.dart';
import '../../wishlist/controller/wishlist_toggle_controller.dart';
import '../controller/home_screen_controller.dart';
import '../screen/home_screen.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=> LocationController(), fenix: true);
    Get.lazyPut(()=> ScrollStatusController(), fenix: true);
    Get.lazyPut(()=> CategoryController(), fenix: true);
    Get.lazyPut(()=> ServiceListController(), fenix: true);
    Get.lazyPut(()=> HomeScreenController(), fenix: true);
    Get.lazyPut(()=> ServiceDeleteController(), fenix: true);
    Get.lazyPut(()=> WishlistToggleController(), fenix: true);
    Get.lazyPut(()=> BookingController(), fenix: true);
    Get.lazyPut(()=> ServiceListByUserController(), fenix: true);
    Get.lazyPut(()=> BookingDeleteController(), fenix: true);
    Get.lazyPut(()=> UserProfileController(), fenix: true);

  }
}