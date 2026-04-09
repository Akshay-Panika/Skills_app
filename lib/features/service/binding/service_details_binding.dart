import 'package:get/get.dart';
import '../controller/service_details_controller.dart';
import '../../account/controller/user_profile_controller.dart';
import '../../location/controller/location_controller.dart';

class ServiceDetailsBinding extends Bindings {
  @override
  void dependencies() {

    /// Service Details Controller
    Get.lazyPut<ServiceDetailsController>(
          () => ServiceDetailsController(),
    );

    /// User Profile Controller
    Get.lazyPut<UserProfileController>(
          () => UserProfileController(),
    );

    /// Location Controller (agar already global nahi hai)
    Get.lazyPut<LocationController>(
          () => LocationController(),
    );
  }
}