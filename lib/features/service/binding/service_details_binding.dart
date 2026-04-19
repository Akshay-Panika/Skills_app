import 'package:get/get.dart';
import '../controller/booking_check_controller.dart';
import '../controller/booking_create_controller.dart';
import '../controller/recent_view_controller.dart';
import '../controller/service_details_controller.dart';


class ServiceDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecentViewController>(() => RecentViewController(),fenix: true);
    Get.lazyPut<ServiceDetailsController>(() => ServiceDetailsController(),fenix: true);
    Get.lazyPut<BookingCheckController>(() => BookingCheckController(), fenix: true);
    Get.lazyPut<BookingCreateController>(() => BookingCreateController(), fenix: true);
  }
}