import 'package:get/get.dart';
import '../controller/service_details_controller.dart';
import '../../account/controller/user_profile_controller.dart';
import '../../location/controller/location_controller.dart';

class ServiceDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceDetailsController>(() => ServiceDetailsController());
    Get.lazyPut<UserProfileController>(() => UserProfileController());
    Get.lazyPut<LocationController>(() => LocationController());
  }
}