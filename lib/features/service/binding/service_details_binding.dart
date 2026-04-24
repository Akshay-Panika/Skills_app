import 'package:get/get.dart';
import '../../chat/controller/chat_controller.dart';
import '../controller/recent_view_controller.dart';
import '../controller/service_details_controller.dart';


class ServiceDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecentViewController>(() => RecentViewController(),fenix: true);
    Get.lazyPut<ServiceDetailsController>(() => ServiceDetailsController(),fenix: true);
    Get.lazyPut<ChatController>(() => ChatController(),fenix: true);
  }
}