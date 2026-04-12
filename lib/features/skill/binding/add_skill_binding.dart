import 'package:get/get.dart';
import '../../subcategory/controller/subategory_controller.dart';
import '../controller/add_service_by_user_controller.dart';

class AddSkillBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubCategoryController>(() => SubCategoryController(),fenix: true);
    Get.lazyPut<AddServiceByUserController>(() => AddServiceByUserController(),fenix: true);
  }
}